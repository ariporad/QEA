function Z = generatePotentialCircle(X, Y, center, r, steps)
    circ = 2 * pi * r;

    if nargin < 5
        steps = circ * 25;
    end
    
    Z = 0;
    
    for theta = linspace(0, 2 * pi, steps)
        x = (r * cos(theta)) + center(1);
        y = (r * sin(theta)) + center(2);
        
        Z = Z + log(sqrt(abs(X - x) .^ 3 + abs(Y - y) .^ 3));
    end
end

