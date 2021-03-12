function res = boat_analysis()
% Note: This code has *almost* everything you need to generate a righting 
% arm curve. Your task is to complete the buoyancy(d) function below.
% The buoyancy(d) function is defined at the bottom of the file;
% this code will not run until you complete it!!!

%% housekeeping
clf % clear the current figure
infill1color = [0.9290 0.6940 0.1250]; % define the color of the boat
infill2color = [0.6290 0.2940 0.0250]; % define the color of the boat
watercolor = [0 0.4470 0.7410]; % define the color of the water
%% design parameters
W = 0.10; % this is a MAX width
H = 0.05; % height m

L = 0.12; % length m 

infill_cutoff_height = 0.02;

%% Infill Parameters
infill_l1 = 1;
infill_l2 = 0.25;
rho_infill = 1250; % kg / m^3
rho_l1 = rho_infill * infill_l1;
rho_l2 = rho_infill * infill_l2;

fun_rho = @(y) rho_l1 * (y < infill_cutoff_height) + rho_l2 * (y >= infill_cutoff_height);

%% physical constants
wrho = 1000; % water density kg/m^3
g = 9.8; % gravity m/s^2
%% boat definition and key variables
Npts = 200; % number of 1D spatial points (probably don't change)
xPoints = linspace(-W/2,W/2,Npts); % set of points in the x direction (horizontal)
zPoints = linspace(0,H,Npts); % set of points in the z direction (vertical)

[X, Z] = meshgrid(xPoints, zPoints); % create the meshgri
P = [X(:)'; Z(:)']; % pack the points into a matrix

% for param_1=0:50:1000 

figure(1); clf;

% for param_2=0.01:0.01:0.25

%% Boat Shape
param_1 = 750
param_2 = 0.075


insideBoat = transpose(P(2, :) >= ((abs(P(1, :))/param_1).^(1/3) + ((abs(P(1, :) / param_2) .^ 8))) & P(2,:) <= H)
% insideBoat = transpose(P(2,:) >= H*abs((2*P(1,:)/W)).^n & P(2,:) <= H); % find all the points inside the boat - a logical array

scatter(P(1,insideBoat),P(2,insideBoat),[],infill1color), axis equal, axis([-max(W,H) max(W,H) -max(W,H) max(W,H)]), hold on % plot the boat

title(sprintf("param_1 = %d, param_2 = %d", param_1, param_2))

drawnow

% end

% end


dx = xPoints(2)-xPoints(1); % delta x
dz = zPoints(2)-zPoints(1); % delta z
dA = dx*dz; % define the area of each small section
boatmasses = (insideBoat * dA * L) .* fun_rho(P(2, :)')
% boatmasses_matrix = reshape(boatmasses, [Npts Npts]);
% boatmasses_vector = sum(boatmasses_matrix, 2)
% boatmasses_area = sum(boatmasses_matrix != 0, 2)

% accumulated_mass = 0
% accumulated_area = 0
% layer = 0

% for layer=1:length(boatmasses_vector)
%     accumulated_mass = accumulated_mass + boatmasses_vector(i)
%     accumulated_area = accumulated_area + (boatmasses_area(i) * dA)

%     if accumulated_mass >= (accumulated_area * wrho)
%         break
%     end
% end

% d = P(2, Npts * layer)

maxdisp = sum(boatmasses); % find the maximum displacement
boatdisp = maxdisp
CoD = P*boatmasses/maxdisp; % find the centroid of the boat
P = P - CoD; % center the boat on the centroid
CoD = CoD - CoD; % update the centroid
CoM = CoD; % set the center of mass
%% main loop over the heel angles
dtheta = 1; % define the angle step
R = [cosd(dtheta) sind(dtheta); -sind(dtheta) cosd(dtheta)]; % define rotation matrix
j = 1; % set the counter

figure(2);

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
    hold off % prepare the figure

    is_infill1 = insideBoat & (P(2, :) < infill_cutoff_height)';
    is_infill2 = insideBoat & (P(2, :) >= infill_cutoff_height)';
    scatter(P(1,is_infill1),P(2,is_infill1),[],infill1color), axis equal, axis([-max(W,H) max(W,H) -max(W,H) max(W,H)]), hold on % plot the boat
    scatter(P(1,is_infill2),P(2,is_infill2),[],infill2color)
    scatter(P(1,underWaterAndInsideBoat),P(2,underWaterAndInsideBoat),[],watercolor) % plot the underwater section
    scatter(CoM(1,1), CoM(2,1), 1000, 'r.'); % plot the COM
    scatter(CoB(1,1), CoB(2,1), 1000, 'k.'); % plot the COB
    title(sprintf("Boat at Heel Angle: theta = %d deg", theta))
    drawnow % force the graphics
    P = R*P; % rotate the boat a little
    CoM = R*CoM; % rotate the center of mass too
    j = j + 1; % update the counter
end
%% plot the moment arm versus the angle
figure(3); clf; hold on;
plot(angle, moment_arm) % plot the data
plot(linspace(0, 180, 10), zeros(10))
legend("Moment Arm Curve", "Equilibria")
title("Moment Arm Curve")
xlabel('Heel Angle (degrees)') 
ylabel('Moment Arm (m)')
grid on; hold off

%% TODO: Complete the bouyancy function - should be zero when balanced
function res = buoyancy(d)
    underWater = (P(2,:) <= d)'; % find meshgrid points under the water
    
    % begin task
    % underWaterAndInsideBoat = boolean vector for inside boat and under water
    % watermasses = the mass of each underwater section; 0 if not part of
    %     submerged boat
    % watermass = mass of the displaced water
    % end task
    
    % This is just from lines 55-58... ???
    underWater = (P(2,:) <= d)'; % test if each part of the meshgrid is under the water
    underWaterAndInsideBoat = insideBoat & underWater;  % the & returns 1 if both conditions are true
    watermasses = (underWaterAndInsideBoat * dA * L) .* fun_rho(P(2, :)'); % compute the mass of each underwater section
    watermass = sum(watermasses); % sum up the under water masses
    
    CoB = P * watermasses ./ watermass; % mass average of the under water boat points
    res = watermass - boatdisp; % difference between boat displacement and water displacement
end

end