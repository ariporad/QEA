function [f, Z] = gauntletPotentialField()
    syms X Y;

    wall = log(sqrt((Y + 3.37) .^ 2)) + log(sqrt((Y - 1) .^ 2)) + log(sqrt((X + 1.5) .^ 2)) + log(sqrt((X - 2.5) .^ 2));
    
%     obstacles = ...
%         log(sqrt((X + 0.25) .^ 2 + (Y + 1.00) .^ 2)) + ...
%         log(sqrt((X - 1.41) .^ 2 + (Y + 2.00) .^ 2)) + ...
%         log(sqrt((X - 1.00) .^ 2 + (Y + 0.70) .^ 2));

    obstacle_info = [   -0.25, -1.0, pi/4, 0.5;
                         1.41, -2.0,    0, 0.5;
                         1.00, -0.7, pi/4, 0.5];

    obstacles = 0;

    for i=1:size(obstacle_info, 1)
        obstacles = obstacles + ...
            log(sqrt((X - obstacle_info(i, 1)) .^ 2 + (Y - obstacle_info(i, 2)) .^ 2));
        
        corners = squareToLines(obstacle_info(i, 1), obstacle_info(i, 2), obstacle_info(i, 3), obstacle_info(i, 4));
        
        for j=1:size(corners, 1)
            obstacles = obstacles + ...
                log(sqrt((X - corners(j, 1)) .^ 2 + (Y - corners(j, 2)) .^ 2));
        end
    end

    Z = (0.1 * obstacles) ...
        + (0.1 * wall) ...
        - (1.5 * log(sqrt((X - 0.75) .^ 2 + (Y + 2.50) .^ 2)));
    f = matlabFunction(Z);
end