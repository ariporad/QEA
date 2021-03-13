function avs=find_avs(min_angle, max_angle, W, H, L, infill_cutoff_height, a, b)
	% Note: This code has *almost* everything you need to generate a righting 
	% arm curve. Your task is to complete the buoyancy(d) function below.
	% The buoyancy(d) function is defined at the bottom of the file;
	% this code will not run until you complete it!!!
	
	%% design parameters
	
	%% Infill Parameters
	infill_l1 = 1;
	infill_l2 = 0.10;
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
	CoD = CoD - CoD; % update the centroid
	CoM = CoD; % set the center of mass

	avs = fzero(@calculate_moment_arm, [min_angle, max_angle]);

	function moment_arm = calculate_moment_arm(theta)
		R = [cosd(theta) sind(theta); -sind(theta) cosd(theta)]; % define rotation matrix
		P_R = R * P;
		CoM_R = R * CoM;
		dmin = min(P_R(2,:)); % find the minimum z coordinate of the boat
		dmax = max(P_R(2,:)); % find the maximum z coordinate of the boat
		d = fzero(@buoyancy,[dmin,dmax]); % find the waterline d
		underWater = (P_R(2,:) <= d)'; % test if each part of the meshgrid is under the water
		underWaterAndInsideBoat = insideBoat & underWater;  % the & returns 1 if both conditions are true
		watermasses = underWaterAndInsideBoat*wrho*dA*L; % compute the mass of each underwater section
		watermass = sum(watermasses); % sum up the under water masses
		CoB = P_R*watermasses./watermass; % mass average of the under water boat points
		moment_arm = CoB(1, 1) - CoM_R(1, 1);

		%% TODO: Complete the bouyancy function - should be zero when balanced
		function res = buoyancy(d)
    underWater = (P_R(2,:) <= d)'; % test if each part of the meshgrid is under the water
    underWaterAndInsideBoat = insideBoat & underWater;  % the & returns 1 if both conditions are true
    watermasses = (underWaterAndInsideBoat * dA * L) .* wrho;%fun_rho(P(2, :)'); % compute the mass of each underwater section
    watermass = sum(watermasses); % sum up the under water masses
    
    CoB = P_R * watermasses ./ watermass; % mass average of the under water boat points
    res = watermass - boatdisp; % difference between boat displacement and water displacement
		end
	end
	
	
end