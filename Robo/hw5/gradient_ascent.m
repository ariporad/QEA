function [rs, headings] = gradient_ascent(f, grad, r_0, heading_0, lambda_0, delta, tolerance, max_steps)
    %% Setup
    % We start with all the lists at length 100, then double the length
    % whenever the limit is hit. This is far more performant than extending
    % the list on each loop iteration.
    i_max = 100;
    rs = zeros(i_max, 2);
    lambdas = zeros(i_max, 1);
    headings = zeros(i_max, 2);

    rs(1, :) = r_0;
    lambdas(1) = lambda_0;
    headings(1, :) = heading_0 ./ norm(heading_0);

    %% Calculate Each Point
    i = 2;
    while i < max_steps
        %% Do Math
        lambdas(i) = lambdas(i - 1) .* delta;
        gradient = grad(rs(i - 1, 1), rs(i - 1, 2))';
        rs(i, :) = rs(i - 1, :) + (lambdas(i - 1) .* gradient);
        
        headings(i, :) = gradient ./ norm(gradient);
        
        %% Exit Condition
        if abs(vecnorm(rs(i, :) - rs(i - 1, :))) < tolerance
            break
        end
        
        %% Expand lists as needed
        if i == i_max
            rs = [rs; zeros(i_max, 2)];
            lambdas = [lambdas; zeros(i_max, 1)];
            headings = [headings; zeros(i_max, 2)];
            i_max = i_max * 2;
        end
        
        %% Increment Counter
        i = i + 1;
    end

    %% Trim Lists
    rs = rs(1:i, :);
    lambdas = lambdas(1:i, :);
    headings = headings(1:i, :);
end