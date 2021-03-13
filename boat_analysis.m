function res = boat_analysis(draw, min_angle, max_angle, angle_step, W, H, L, infill_cutoff_height, a, b)
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

if draw
    figure(1); clf; 
    scatter(P(1,is_infill1),P(2,is_infill1),[],infill1color), axis equal, axis([-max(W,H) max(W,H) -max(W,H) max(W,H)]), hold on; % plot the boat
    scatter(P(1,is_infill2),P(2,is_infill2),[],infill2color);
    title(sprintf("Boat (infill cutoff = %d, a = %d, b = %d)", infill_cutoff_height, a, b));
    drawnow
    grid on;
    hold off;
end

dx = xPoints(2)-xPoints(1); % delta x
dz = zPoints(2)-zPoints(1); % delta z
dA = dx*dz; % define the area of each small section
boatmasses = (insideBoat * dA * L) .* fun_rho(P(2, :)');

maxdisp = sum(boatmasses); % find the maximum displacement
boatdisp = maxdisp;
CoD = P*boatmasses/maxdisp; % find the centroid of the boat

P = P - CoD; % center the boat on the centroid
CoD = CoD - CoD; % update the centroid
CoM = CoD; % set the center of mass
%% main loop over the heel angles
dtheta = 1; % define the angle step
R = [cosd(dtheta) sind(dtheta); -sind(dtheta) cosd(dtheta)]; % define rotation matrix
j = 1; % set the counter

if draw
    figure(2);
end

for theta = 0:dtheta:180 % loop over the angles
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

    if draw
        hold off; % prepare the figure

        scatter(P(1,is_infill1),P(2,is_infill1),[],infill1color), axis equal, axis([-max(W,H) max(W,H) -max(W,H) max(W,H)]), hold on; % plot the boat
        scatter(P(1,is_infill2),P(2,is_infill2),[],infill2color);
        scatter(P(1,underWaterAndInsideBoat),P(2,underWaterAndInsideBoat),[],watercolor); % plot the underwater section
        scatter(CoM(1,1), CoM(2,1), 1000, 'r.'); % plot the COM
        scatter(CoB(1,1), CoB(2,1), 1000, 'k.'); % plot the COB
        title(sprintf("Boat at Heel Angle: theta = %d deg", theta));
        drawnow; % force the graphics
    end

    P = R*P; % rotate the boat a little
    CoM = R*CoM; % rotate the center of mass too
    j = j + 1; % update the counter
end

if draw
    %% plot the moment arm versus the angle
    figure(3); clf; hold on;
    plot(angle, moment_arm); % plot the data
    legend("Moment Arm Curve");
    title("Moment Arm Curve");
    xlabel('Heel Angle (degrees)');
    ylabel('Moment Arm (m)');
    grid on; hold off;
end

%% TODO: Complete the bouyancy function - should be zero when balanced
function res = buoyancy(d)
    underWater = (P(2,:) <= d)'; % find meshgrid points under the water
    
    underWater = (P(2,:) <= d)'; % test if each part of the meshgrid is under the water
    underWaterAndInsideBoat = insideBoat & underWater;  % the & returns 1 if both conditions are true
    watermasses = (underWaterAndInsideBoat * dA * L) .* fun_rho(P(2, :)'); % compute the mass of each underwater section
    watermass = sum(watermasses); % sum up the under water masses
    
    CoB = P * watermasses ./ watermass; % mass average of the under water boat points
    res = watermass - boatdisp; % difference between boat displacement and water displacement
end

end
