%First we must define the symbolic variables we will being using
syms t omega v_l v_r

assume(t, {'real', 'positive'}) % parameter t should be real
assume(omega, 'real')
assume(v_l, 'real')
assume(v_r, 'real')
% assumeAlso(u >= 0)
% assumeAlso(u <= 3.2)


u = t .* alpha;

%Define the equation for the parametric circle. For clarity, I am first 
%creating individual equations for r in the i, j, and k direction, 
%then packing them in one vector. In this case, we are
%creating a 1x3 vector that has symbolic equations for the i, j, and k
%components of the equation, respectively. Note that the k component in
%this case is just equal to 0. We use 0*u because if we substitute a vector
%of numerical values in for the symbolic u at a later time, the dimensions
%of the vector will be consistent.
ri=4 * (0.3960 * cos(2.65 * (u + 1.4)));
rj=4 * (-0.99 * sin(u + 1.4));
rk=0*u;
r=[ri,rj,rk];


%to take the derivative, we use the diff function in Matlab, with the
%inputs being diff(function,variable to differentiate)
dr=diff(r,t);
v = dr;
speed = norm(v);
T_hat=simplify(dr./norm(dr));

%Next, we want to find the unit normal vector
dT_hat=simplify(diff(T_hat,t));
omega = simplify(cross(T_hat, dT_hat));
% KLUDGE: This isn't super mathamatically sound (or maybe it is?) but it's
% correct in practice
rotation_speed = omega(3); %simplify(norm(omega))
v_l = simplify(speed - (rotation_speed * (d / 2)));
v_r = simplify(speed + (rotation_speed * (d / 2)));

N_hat=simplify(dT_hat/norm(dT_hat));