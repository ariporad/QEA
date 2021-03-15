function res = sweep_moment_arm(boat, min_angle, angle_step, max_angle, draw_boats, draw_moment_arm)
    angles = min_angle:angle_step:max_angle;

    for j = 1:length(angles)
        rboat = analyze_boat(boat, angles(j));

        waterline(j) = rboat.d;
        moment_arms(j) = rboat.moment_arm;

        if draw_boats
            draw_boat(rboat, sprintf("Cross-Section of the Boat at Midship, Equilibrium Water Level, and Heel Angle %d deg", angles(j)))
        end
    end

    if draw_moment_arm
        %% plot the moment arm versus the angle
        clf; hold on;
        plot(angles, moment_arms); % plot the data
        title("Moment Arm Curve");
        xlabel('Heel Angle (degrees)');
        ylabel('Moment Arm (m)');
        grid on; hold off;
    end
end
