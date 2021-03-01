function [centerOfMass, centerOfBuoyancy, pointsInBoat] = simulate_duckie(predicate)
    density = 1;
    
    xPoints = linspace(-10, 10, 1000);
    yPoints = linspace(0, 10, 1000);
    
    % I couldn't figure out that I needed to do this without the solutions
    areaPerCell = (xPoints(2) - xPoints(1)) * (yPoints(2) - yPoints(1)); % area represented by each point
    
    [X, Y] = meshgrid(xPoints, yPoints);
    P = [X(:)'; Y(:)'];
    
    isInsideBoat = predicate(P);
    pointsInBoat = P(:, isInsideBoat);
    massScalar = (isInsideBoat * density * areaPerCell);
    centerOfMass = (P * massScalar') / sum(massScalar, 2);
    areaScalar = isInsideBoat * areaPerCell;
    centerOfBuoyancy = (P * areaScalar') / sum(areaScalar);
end


