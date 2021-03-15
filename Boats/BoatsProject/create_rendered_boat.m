function rboat = create_rendered_boat(boat, theta)
    Npts = 200; % number of 1D spatial points (probably don't change)
    xPoints = linspace(-boat.W/2,boat.W/2,Npts); % set of points in the x direction (horizontal)
    zPoints = linspace(0,boat.H,Npts); % set of points in the z direction (vertical)

    [X, Z] = meshgrid(xPoints, zPoints); % create the meshgrid
    P = [X(:)'; Z(:)']; % pack the points into a matrix
    dx = xPoints(2)-xPoints(1); % delta x
    dz = zPoints(2)-zPoints(1); % delta z
    dA = dx*dz; % define the area of each small section

	is_inside = boat.predicate(boat, P);
	is_infill_l1 = is_inside & (P(2, :) < boat.infill_cutoff)';
	is_infill_l2 = is_inside & (P(2, :) >= boat.infill_cutoff)';

	rboat = struct("boat", boat, "P", P, "dx", dx, "dz", dz, "dA", dA, "is_inside", is_inside, "is_infill_l1", is_infill_l1, "is_infill_l2", is_infill_l2);

	[mass, CoM] = calculate_rboat_mass(rboat);

	% It's possible we can't rotate before calculating the CoM
	% We definitely can't before running the predicate
	rboat.P = [cosd(theta) sind(theta); -sind(theta) cosd(theta)] * rboat.P;

	rboat.mass = mass;
	rboat.CoM = [cosd(theta) sind(theta); -sind(theta) cosd(theta)] * CoM;

	rboat.P = rboat.P - rboat.CoM;
	rboat.CoM = rboat.CoM - rboat.CoM;


end