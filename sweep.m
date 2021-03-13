function cutoff = sweep(boat, min_angle, max_angle, min_cutoff, max_cutoff)
	cutoff = fzero(@test_cutoff, [min_cutoff, max_cutoff]);
	function err = test_cutoff(cutoff)
		boat.infill_cutoff = cutoff;
		err = 130 - find_avs(boat, min_angle, max_angle);
	end
end
