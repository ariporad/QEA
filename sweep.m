function height = sweep(min_angle, max_angle, W, H, L, min_cutoff_height, max_cutoff_height, a, b)
	height = fzero((@(h) 130 - find_avs(min_angle, max_angle, W, H, L, h, a, b)), [min_cutoff_height, max_cutoff_height]);
end