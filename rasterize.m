%% Rasterize a vector-based image
% Given a series of x/y points along strokes of an image, render a raster.
%
% Points should be a nx2 matrix, where each row is [x, y] of a point. Use
% [NaN, NaN] as a row to separate two strokes of an image.
%
% The resulting image will be an img_size'd square image, as an
% img_sizeximage_size matrix with values from 0 to 255. (Same format as
% imagesc.)
function img = rasterize(points, img_size)
	%% Configuration
	STROKE_COLOR = 0;
	BACKGROUND_COLOR = 255;

	% This is used to figure out how many steps to make per pixel of
    % difference in end points when drawing strokes. For example, if this
    % is set to 5, and a stroke is being drawn between (1, 1) and (1, 2),
    % it will draw 5 substeps. This is a bad kludge to make some diagonals
    % a bit smoother. It's not great, but it works.
	AGGRESSIVENESS = 5;

	%% Initialization
	img = ones(img_size, img_size) * BACKGROUND_COLOR;

	%% Scaling
	% We want to scale each image to be full width/width on the largest
    % dimension while preserving the aspect ratio on the other dimension.
    % Additionally, we want to center it on the smaller axis.
	
	shifts = [0, 0]; % Later used to shift all pixels

	% Scaling
	actual_dimensions = range(points);
	[~, largest_axis_idx] = max(actual_dimensions);
	[~, smallest_axis_idx] = min(actual_dimensions);
    % img_size - 1 avoids ending up with pixels at index 0.
	scale_factor = (img_size - 1) / actual_dimensions(largest_axis_idx);
	points = points .* scale_factor;
    % shift so range is [1, width]
	shifts(largest_axis_idx) = 1 - min(points(:, largest_axis_idx));
    
    % Update to account for scaling
	actual_dimensions = range(points);
    
	% Centering
	edge_target = floor((img_size - actual_dimensions(smallest_axis_idx)) / 2);
	edge_offset = edge_target - min(points(:, smallest_axis_idx));
	shifts(smallest_axis_idx) = edge_offset;

	points = points + shifts;
    
    %% Sanity Check
    mins = min(points);
    maxes = max(points);
    assert(...
        all(max(points) <= img_size) && all(min(points) >= 1), ...
        sprintf(...
            "Sanity Check Failed! Failed to scale and center image so all points were within (%1.0f, %1.0f)! Mins: (%1.2f, %1.2f), Maxes: (%1.2f, %1.2f)", ...
            img_size, img_size, mins(1), mins(2), maxes(1), maxes(2) ...
        ) ...
    );

	%% Drawing
    for idx=1:size(points, 1)
		%% Stroke Separation
		% If a point is [NaN, NaN], it indicates the break between two
        % strokes, so skip it.
		if isnan(points(idx, 1)) || isnan(points(idx, 2))
			continue;
		end

		%% Handle First Points of Stroke
		% For the first point of a stroke (either the first point period or
        % the first point after a NaN), we simply draw the point itself and
        % continue, since there's no stroke to draw.
		if idx == 1 || isnan(points(idx - 1, 1)) || isnan(points(idx - 1, 2))
			img(round(points(idx, 2)), round(points(idx, 1))) = STROKE_COLOR;
			continue;
		end

		%% Drawing Initialization
		dX = points(idx, 1) - points(idx - 1, 1);
		dY = points(idx, 2) - points(idx - 1, 2);

		% This tries to guess the number of substeps we ought to need to
        % draw the line, then increases it using the kludge of
        % AGGRESSIVENESS to make sure the lines are smooth. Improving this
        % algorithm would improve the rasterization, but I don't think it's
        % that important.
		num_steps = AGGRESSIVENESS * max([ ...
            1, ... % always at least one substep
            abs(dX), abs(dY), ... % for a horiz/vertical line, its distance
            sqrt((dX ^ 2) + (dY ^ 2)) ... % for a diagonal, its distance
        ]);

		x_step = dX / num_steps;
		y_step = dY / num_steps;

		x_pos = points(idx - 1, 1);
		y_pos = points(idx - 1, 2);

		%% Drawing
		% I'm a little worried that we're going to get floating point
		% errors here, but it hasn't been an issue yet.
		for j=1:num_steps
			x_pos = x_pos + x_step;
			y_pos = y_pos + y_step;
			img(round(y_pos), round(x_pos)) = STROKE_COLOR;
        end
    end

    % MATLAB's y-axis for images is flipped from its y-axis for
    % figures/drawing, so we need to flip the output image so its
    % right-side up.
	img = flip(img, 1);
end