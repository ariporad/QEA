function res = sweep_moment_arm(boat, min_angle, angle_step, max_angle, draw)
    %% Setup
    infill1color = [0.9290 0.6940 0.1250]; % define the color of the 1st infill zone
    infill2color = [0.6290 0.2940 0.0250]; % define the color of the 2nd infill zone
    watercolor = [0 0.4470 0.7410]; % define the color of the water

    if draw
        clf;
    end

    angles = min_angle:angle_step:max_angle;

    for j = 1:length(angles)
        [rboat, d, CoB, moment_arm, is_inside_underwater] = analyze_boat(boat, angles(j));

        waterline(j) = d;
        moment_arms(j) = moment_arm;

        if draw
            hold off; % prepare the figure

            scatter(rboat.P(1,rboat.is_infill_l1),rboat.P(2,rboat.is_infill_l1),[],infill1color, 'filled')
            axis equal;
            axis([-max(boat.W,boat.H) max(boat.W,boat.H) -max(boat.W,boat.H) max(boat.W,boat.H)]);
            hold on;
            scatter(rboat.P(1,rboat.is_infill_l2),rboat.P(2,rboat.is_infill_l2),[],infill2color, 'filled');
            scatter(rboat.P(1,is_inside_underwater),rboat.P(2,is_inside_underwater),[],watercolor, 'filled');
            scatter(rboat.CoM(1,1), rboat.CoM(2,1), 1000, 'r.');
            scatter(CoB(1,1), CoB(2,1), 1000, 'k.');
            title(sprintf("Cross-Section of the Boat at Midship, Equilibrium Water Level, and Heel Angle %d deg", angles(j)));
            legend(sprintf("Boat: Infill Level 1 (%d%%)", boat.infill_l1 * 100), sprintf("Boat: Infill Level 2 (%d%%)", boat.infill_l2 * 100), "Water", "Center of Mass", "Center of Buoyancy")
            title("X-Axis (m)")
            title("Z-Axis (m)")
            drawnow; % force the graphics
        end
    end

    if draw
        %% plot the moment arm versus the angle
        figure; clf; hold on;
        plot(angles, moment_arms); % plot the data
        legend("Moment Arm Curve");
        title("Moment Arm Curve");
        xlabel('Heel Angle (degrees)');
        ylabel('Moment Arm (m)');
        grid on; hold off;
    end
end
