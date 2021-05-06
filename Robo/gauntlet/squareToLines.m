function points = squareToLines(center_x, center_y, angle, side_length)
    lines = NaN(4,4);
    
    offset = side_length/2;
    points = [  +offset, -offset, -offset, +offset;
                +offset, +offset, -offset, -offset;
                1,1,1,1];
    % rotate
    points = [  cos(angle), -sin(angle), 0;
                sin(angle),  cos(angle), 0;
                0,0,1] * points;

    % translate
    points = [  1, 0, center_x;
                0, 1, center_y;
                0, 0, 1] * points;
    
    points = points(1:2, :)';
    
    
%     for i=1:3
%         lines(i,:) = [points(i,1), points(i,2), points(i+1,1), points(i+1,2)];
%     end
%     lines(4,:) = [points(4,1), points(4,2), points(1,1), points(1,2)];
end