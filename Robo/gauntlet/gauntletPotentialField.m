function [f, Z] = gauntletPotentialField()
    syms X Y

    wall_lines = [
        -1.5, -3.37, -1.5,     1;
         2.5, -3.37,  2.5,     1;
         2.5, -3.37, -1.5, -3.37;
         2.5,     1, -1.5,      1 
    ];

    obstacle_info = [   -0.25, -1.0, pi/4, 0.5;
                         1.41, -2.0,    0, 0.5;
                         1.00, -0.7, pi/4, 0.5];

    obstacle_lines = [];

    for i=1:size(obstacle_info, 1)
        obstacle_lines = [obstacle_lines; squareToLines(obstacle_info(i, 1), obstacle_info(i, 2), obstacle_info(i, 3), obstacle_info(i, 4))];
    end

    Z = + 2 * generatePotentialLines(X, Y, obstacle_lines) ...
        - 0.5 * abs(generatePotentialLines(X, Y, wall_lines)) ...
        - 15 * generatePotentialCircle(X, Y, [.75, -2.5], .25);
    f = matlabFunction(Z);
end