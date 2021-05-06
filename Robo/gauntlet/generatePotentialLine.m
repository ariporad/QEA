function Z = generatePotentialLine(X, Y, start, endpoint, steps)
    length = norm(endpoint - start);

    if nargin < 5
        steps = length * 25;
    end
    
    dx = (endpoint(1) - start(1)) / steps;
    dy = (endpoint(2) - start(2)) / steps;
    
    Z = 0;
    
    for i = 0:steps
        x = start(1) + (dx * i);
        y = start(2) + (dy * i);
        
        Z = Z + log(sqrt((X - x) .^ 2 + (Y - y) .^ 2)^2);
    end
end

