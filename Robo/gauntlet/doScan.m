%% A helper script to invoke collectScans.m from within the simulator
% The simulator was so laggy that typing in all these positions was
% untennable.
positions = [
    % x, y, phi
      0,    0, 0;
      0, -2.5, 0;
      2,    0, 0;
    1.5, -1.5, 0;
    1.8, -2.7, 0;
];

collectScans(positions, "lidar.mat");