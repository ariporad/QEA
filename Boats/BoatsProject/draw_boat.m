function res = draw_boat(rboat, description, varargin)
    %% Setup
    infill1color = [0.9290 0.6940 0.1250]; % define the color of the 1st infill zone
    infill2color = [0.6290 0.2940 0.0250]; % define the color of the 2nd infill zone
    watercolor = [0 0.4470 0.7410]; % define the color of the water

    boat = rboat.boat;

    clf;
    scatter(rboat.P(1,rboat.is_infill_l1),rboat.P(2,rboat.is_infill_l1),[],infill1color, 'filled')
    axis equal;
    axis([-max(boat.W,boat.H) max(boat.W,boat.H) -max(boat.W,boat.H) max(boat.W,boat.H)]);
    hold on;
    scatter(rboat.P(1,rboat.is_infill_l2),rboat.P(2,rboat.is_infill_l2),[],infill2color, 'filled');
    scatter(rboat.CoM(1,1), rboat.CoM(2,1), 1000, 'r.');
    if ~ismember('nowater', varargin)
        scatter(rboat.CoB(1,1), rboat.CoB(2,1), 1000, 'k.');
        scatter(rboat.P(1,rboat.is_inside_underwater),rboat.P(2,rboat.is_inside_underwater),[],watercolor, 'filled');
    end
    title(description);
    warning('off', 'MATLAB:legend:IgnoringExtraEntries')
    legend(sprintf("Boat: Infill Level 1 (%d%%)", boat.infill_l1 * 100), sprintf("Boat: Infill Level 2 (%d%%)", boat.infill_l2 * 100), "Center of Mass", "Center of Buoyancy", "Water")
    warning('on', 'MATLAB:legend:IgnoringExtraEntries')
    xlabel("X-Axis (m)")
    ylabel("Z-Axis (m)")
    drawnow; % force the graphics
    hold off; % prepare the figure
end