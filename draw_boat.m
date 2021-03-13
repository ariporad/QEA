function res = draw_boat(theta, W, H, L, infill_cutoff_height, a, b)
    figure;

%% Setup
clf; % clear the current figure
infill1color = [0.9290 0.6940 0.1250]; % define the color of the 1st infill zone
infill2color = [0.6290 0.2940 0.0250]; % define the color of the 2nd infill zone
watercolor = [0 0.4470 0.7410]; % define the color of the water

%% physical constants
rho_infill = 1250; % kg / m^3
wrho = 1000; % water density kg/m^3
g = 9.8; % gravity m/s^2

%% Infill Parameters
infill_l1 = 1; % 100% infill
infill_l2 = 0.10; % 10% infill
rho_l1 = rho_infill * infill_l1;
rho_l2 = rho_infill * infill_l2;

fun_rho = @(y) rho_l1 * (y < infill_cutoff_height) + rho_l2 * (y >= infill_cutoff_height);

%% boat definition and key variables
Npts = 200; % number of 1D spatial points (probably don't change)
xPoints = linspace(-W/2,W/2,Npts); % set of points in the x direction (horizontal)
zPoints = linspace(0,H,Npts); % set of points in the z direction (vertical)

[X, Z] = meshgrid(xPoints, zPoints); % create the meshgri
P = [X(:)'; Z(:)']; % pack the points into a matrix

insideBoat = transpose(P(2, :) >= ((abs(P(1, :))/a).^(1/3) + ((abs(P(1, :) / b) .^ 8))) & P(2,:) <= H);
is_infill1 = insideBoat & (P(2, :) < infill_cutoff_height)';
is_infill2 = insideBoat & (P(2, :) >= infill_cutoff_height)';

dx = xPoints(2)-xPoints(1); % delta x
dz = zPoints(2)-zPoints(1); % delta z
dA = dx*dz; % define the area of each small section
boatmasses = (insideBoat * dA * L) .* fun_rho(P(2, :)');

maxdisp = sum(boatmasses); % find the maximum displacement
boatdisp = maxdisp;
CoD = P*boatmasses/maxdisp; % find the centroid of the boat

P = P - CoD; % center the boat on the centroid
P_orig = P;
CoD = CoD - CoD; % update the centroid
CoM = CoD; % set the center of mass
%% main loop over the heel angles
R = [cosd(theta) sind(theta); -sind(theta) cosd(theta)]; % define rotation matrix
j = 1; % set the counter

P = R * P;
CoM = R * CoM;
dmin = min(P(2,:)); % find the minimum z coordinate of the boat
dmax = max(P(2,:)); % find the maximum z coordinate of the boat
d = fzero(@buoyancy,[dmin,dmax]); % find the waterline d
underWater = (P(2,:) <= d)'; % test if each part of the meshgrid is under the water
underWaterAndInsideBoat = insideBoat & underWater;  % the & returns 1 if both conditions are true
watermasses = underWaterAndInsideBoat*wrho*dA*L; % compute the mass of each underwater section
watermass = sum(watermasses); % sum up the under water masses
CoB = P*watermasses./watermass; % mass average of the under water boat points
waterline(j) = d; % save the waterline
moment_arm(j) = CoB(1, 1) - CoM(1, 1);
angle(j) = theta; % define the angle

    scatter(P(1,is_infill1),P(2,is_infill1),[],infill1color, 'filled'), axis equal, axis([-max(W,H) max(W,H) -max(W,H) max(W,H)]), hold on; % plot the boat
    scatter(P(1,is_infill2),P(2,is_infill2),[],infill2color, 'filled');
    scatter(P(1,underWaterAndInsideBoat),P(2,underWaterAndInsideBoat),[],watercolor, 'filled'); % plot the underwater section
    scatter(CoM(1,1), CoM(2,1), 1000, 'r.'); % plot the COM
    scatter(CoB(1,1), CoB(2,1), 1000, 'k.'); % plot the COB

    legend(sprintf("Infill Level 1 (%d%%)", infill_l1 * 100), sprintf("Infill Level 2 (%d%%)", infill_l2 * 100), "Water", "Center of Mass", "Center of Buoyancy")

    title(sprintf("Cross-Section of the Boat at Midship, Equilibrium Water Level, and Heel Angle %d deg", theta));
    hold off;

    % Displacement Stuff
    underWater = (P(2,:) <= d)'; % find meshgrid points under the water
    
    underWater = (P(2,:) <= d)'; % test if each part of the meshgrid is under the water
    underWaterAndInsideBoat = insideBoat & underWater;  % the & returns 1 if both conditions are true
    watermasses = (underWaterAndInsideBoat * dA * L) .* wrho;
    watermass = sum(watermasses); % sum up the under water masses
    
    CoB = P * watermasses ./ watermass; % mass average of the under water boat points
    dispratio = boatdisp / watermass

%% TODO: Complete the bouyancy function - should be zero when balanced
function res = buoyancy(d)
    underWater = (P(2,:) <= d)'; % find meshgrid points under the water
    
    underWater = (P(2,:) <= d)'; % test if each part of the meshgrid is under the water
    underWaterAndInsideBoat = insideBoat & underWater;  % the & returns 1 if both conditions are true
    watermasses = (underWaterAndInsideBoat * dA * L) .* wrho;
    watermass = sum(watermasses); % sum up the under water masses
    
    CoB = P * watermasses ./ watermass; % mass average of the under water boat points
    res = watermass - boatdisp; % difference between boat displacement and water displacement
end

end
