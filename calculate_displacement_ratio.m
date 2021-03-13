function dispratio = calculate_displacement_ratio(rboat)
	rho_water = 1000; % water density kg/m^3

	dispratio = rboat.mass / sum(((rboat.is_inside * rboat.dA * rboat.boat.L) .* rho_water));
end