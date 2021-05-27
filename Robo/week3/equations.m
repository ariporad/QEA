% First we must define the symbolic variables we will being using:
syms t omega v_l v_r

% Assumptions help MATLAB not go insane
assume(t, {'real', 'positive'})
assume(omega, 'real')
assume(v_l, 'real')
assume(v_r, 'real')

% This isn't actually a symbolic variable, but we'll set it up anyways
% This allows us to modulate the speed of the robot relative to time by
% adjusting alpha
u = t .* alpha;

% Define the curve of the Bridge of Doom (dun dun dun)
ri=4 * (0.3960 * cos(2.65 * (u + 1.4)));
rj=4 * (-0.99 * sin(u + 1.4));
rk=0*u;
r=[ri,rj,rk];

% Calculate the robot's velocity (rate of change of position) and linear
% speed (magnitude of velocity)
v=diff(r,t);
speed = norm(v);

% Calculate the unit tangent and unit normal vectors
T_hat=simplify(v./norm(v));
dT_hat=simplify(diff(T_hat,t));
N_hat=simplify(dT_hat/norm(dT_hat));

% Calculate the rotational velocity and speed
omega = simplify(cross(T_hat, dT_hat));
rotation_speed = omega(3);

% Calculate the wheel velocities
v_l = simplify(speed - (rotation_speed * (d / 2)));
v_r = simplify(speed + (rotation_speed * (d / 2)));
