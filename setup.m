W = 0.10; % this is a MAX width
H = 0.065; % height m
L = 0.12; % length m 

%% Boat Shape
a = 400;
b = 0.067;

min_angle = 120;
max_angle = 140;
angle_step = 1;

infill_cutoff_height = sweep(120, 140, W, H, L, 0.03, 0.04, a, b)

boat_analysis(true, min_angle, max_angle, angle_step, W, H, L, 0.04, a, b)