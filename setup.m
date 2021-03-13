predicate = @(boat, P) transpose(P(2, :) >= ((abs(P(1, :))/boat.a).^(1/3) + ((abs(P(1, :) / boat.b) .^ 8))) & P(2,:) <= boat.H);

W = 0.10; % this is a MAX width
H = 0.065; % height m
L = 0.12; % length m 

%% Boat Shape
a = 400;
b = 0.067;

min_angle = 120;
max_angle = 140;
angle_step = 1;

infill_l1 = 1;
infill_l2 = 0.1;

boat = create_boat(W, H, L, a, b, infill_l1, infill_l2, 0.0370, predicate);

infill_cutoff = sweep(boat, 120, 140, 0.035, 0.04)

sweep_moment_arm(boat, 0, 1, 180, true)