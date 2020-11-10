function img = rasterize(points, width)
	%% Configuration
	STROKE_COLOR = 0;
	BACKGROUND_COLOR = 255;

	% This is used to figure out how many steps to make per pixel of difference in end points when
	% drawing strokes. For example, if this is set to 5, and a stroke is being drawn between (1, 1)
	% and (1, 2), it will draw 5 substeps. This is a kludge, but it works.
	AGGRESSIVENESS = 5;

	%% Sanity Check
	% assert(max(points(:, 1)) <= width, "Error! Point x-values exceed width!");
	% assert(min(points(:, 1)) >= 1, "Error! Point x-values are less than 1!");
	% assert(max(points(:, 2)) <= width, "Error! Point y-values exceed width!");
	% assert(min(points(:, 2)) >= 1, "Error! Point y-values are less than 1!");
	assert(size(points, 2) == 2, "Error! `points` must have two columns!");

	%% Initialization
	img = ones(width, width) * BACKGROUND_COLOR;

	%% Scaling
	% We want to scale each image to be full width/width on the largest dimension while preserving
	% the aspect ratio on the other dimension. Additionally, we want to center it on the smalle axis.
	
	shifts = [0, 0]

	% Scaling
	actual_dimensions = range(points)
	[~, largest_axis_idx] = max(actual_dimensions)
	scale_factor = (width - 1) / actual_dimensions(largest_axis_idx) % width - 1 because 0 isn't a valid index
	points = points .* scale_factor;
	shifts(largest_axis_idx) = 1 - min(points(:, largest_axis_idx)) % shift so range is [1, width]

	% Centering
	[~, smallest_axis_idx] = min(actual_dimensions)
	edge_target = floor((width - actual_dimensions(smallest_axis_idx)) / 2)
	edge_offset = edge_target - min(points(:, smallest_axis_idx)) 
	shifts(smallest_axis_idx) = edge_offset

	points = points + shifts;

	%% Drawing
	for idx=1:size(points, 1)
		%% Stroke Separation
		% If a point is [NaN, NaN], it indicates the separation of two strokes, so skip it.
		if isnan(points(idx, 1)) || isnan(points(idx, 2))
			continue;
		end

		%% Handle First Points of Stroke
		% For the first point of a stroke (either the first point period or the first point after a
		% NaN), we simply draw the point itself and continue, since there's no stroke to draw.
		if idx == 1 || isnan(points(idx - 1, 1)) || isnan(points(idx - 1, 2))
			img(round(points(idx, 2)), round(points(idx, 1))) = STROKE_COLOR;
			continue;
		end

		%% Drawing Initialization
		dX = points(idx, 1) - points(idx - 1, 1);
		dY = points(idx, 2) - points(idx - 1, 2);

		% This tries to guess the number of substeps we need to draw the line, then increases it
		% using the kludge of AGGRESSIVENESS to make sure it works. Improving this algorithm would
		% improve the rasterization, but I don't think we care that much.
		num_steps = max([1, abs(dX), abs(dY), sqrt((dX ^ 2) + (dY ^ 2))]) * AGGRESSIVENESS;

		x_step = dX / num_steps;
		y_step = dY / num_steps;

		x_pos = points(idx - 1, 1);
		y_pos = points(idx - 1, 2);

		%% Drawing
		% I'm a little worried that we're going to get floating point errors here meaning that it
		% doesn't quite add up, but it hasn't been a problem yet.
		for j=1:num_steps
			x_pos = x_pos + x_step
			y_pos = y_pos + y_step
			img(round(y_pos), round(x_pos)) = STROKE_COLOR;
		end
	end

	img = flip(img, 1);
end