function avs = find_avs(boat, min_angle, max_angle)
	avs = fzero(@(theta) analyze_boat(boat, theta).moment_arm, [min_angle, max_angle]);
end