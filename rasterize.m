function img = rasterize(points, width, height)
	%% Configuration
	STROKE_COLOR = 0;
	BACKGROUND_COLOR = 255;

	% This is used to figure out how many steps to make per pixel of difference in end points when
	% drawing strokes. For example, if this is set to 5, and a stroke is being drawn between (1, 1)
	% and (1, 2), it will draw 5 substeps. This is a kludge, but it works.
	AGGRESSIVENESS = 5;

	%% Sanity Check
	assert(max(points(:, 1)) <= width, "Error! Point x-values exceed width!");
	assert(min(points(:, 1)) >= 1, "Error! Point x-values are less than 1!");
	assert(max(points(:, 2)) <= height, "Error! Point y-values exceed height!");
	assert(min(points(:, 2)) >= 1, "Error! Point y-values are less than 1!");
	assert(size(points, 2) == 2, "Error! `points` must have two columns!");

	%% Initialization
	img = ones(height, width) * BACKGROUND_COLOR;

	for idx=1:size(points, 1)
		%% Stroke Separation: Skip NaNs
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
			x_pos = x_pos + x_step;
			y_pos = y_pos + y_step;
			img(round(y_pos), round(x_pos)) = STROKE_COLOR;
		end
	end
end