% Helper function for rotating and translating raw LIDAR data into the
% global reference frame.
function r_G = to_global(R, theta, origin, phi)
    [X_raw, Y_raw] = pol2cart(theta,  R);
    r_L = [X_raw, Y_raw, ones(length(X_raw), 1)]';
    r_N = [1, 0, 0.084; 0, 1, 0; 0, 0, 1] * r_L; % no rotation needed
    r_G_raw = [1, 0, origin(1); 0, 1, origin(2); 0, 0, 1] * [cos(phi), -sin(phi), 0; sin(phi), cos(phi), 0; 0, 0, 1] * r_N;
    r_G = r_G_raw(1:2, :)';
end