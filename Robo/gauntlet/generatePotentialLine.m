function Z = generatePotentialLine(X, Y, start, endpoint, steps)
    if nargin < 5
        steps = 10;
    end
    
    dx = (endpoint(1) - start(1)) / steps;
    dy = (endpoint(2) - start(2)) / steps;
    
    Z = 0;
    
    for i = 0:steps
        x = start(1) + (dx * i);
        y = start(2) + (dy * i);
        
        Z = Z + log(sqrt((X - x) .^ 2 + (Y - y) .^ 2));
    end
end

