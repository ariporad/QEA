function [mass, CoM] = calculate_rboat_mass(rboat)
    rho_infill = 1250; % kg / m^3
	boat = rboat.boat;

    rho_l1 = rho_infill * boat.infill_l1;
    rho_l2 = rho_infill * boat.infill_l2;

    fun_rho = @(y) rho_l1 * (y < boat.infill_cutoff) + rho_l2 * (y >= boat.infill_cutoff);

	masses = rboat.is_inside .* rboat.dA .* rboat.boat.L .* fun_rho(rboat.P(2, :)');
	mass = sum(masses);
	CoM = (rboat.P * masses) ./ mass;
end