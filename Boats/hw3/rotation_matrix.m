function mat = rotation_matrix(angle_ccw)
    mat = [cosd(angle_ccw), -sind(angle_ccw); sind(angle_ccw), cosd(angle_ccw)];
end
