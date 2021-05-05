function Z = generatePotentialLines(X, Y, lines)
    Z = 0;
    
    for i=1:size(lines, 1)
        Z = Z + generatePotentialLine(X, Y, lines(i, 1:2), lines(i, 3:4));
    end
end