function [CoB, watermass, is_inside_underwater] = calculate_rboat_buoyancy(rboat, d)
    rho_water = 1000; % water density kg/m^3

    is_underwater = (rboat.P(2,:) <= d)'; % test if each part of the meshgrid is under the water
    is_inside_underwater = rboat.is_inside & is_underwater;  % the & returns 1 if both conditions are true

    watermasses = is_inside_underwater .* rho_water .* rboat.dA .* rboat.boat.L; % compute the mass of each underwater section
    watermass = sum(watermasses); % sum up the under water masses

    CoB = (rboat.P * watermasses) ./ watermass; % mass average of the under water boat points
end