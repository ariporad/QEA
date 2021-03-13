function [rboat, d, CoB, moment_arm, is_inside_underwater] = analyze_boat(boat, theta)
    rboat = create_rendered_boat(boat, theta);
    dmin = min(rboat.P(2,:)); % find the minimum z coordinate of the boat
    dmax = max(rboat.P(2,:)); % find the maximum z coordinate of the boat

    d = fzero(@(d) buoyancy(rboat, d), [dmin,dmax]); % find the waterline d
    
    [CoB, ~, is_inside_underwater] = calculate_rboat_buoyancy(rboat, d);
    CoB = CoB;
    CoM = rboat.CoM;
    moment_arm = CoB(1, 1) - rboat.CoM(1, 1);

    function res = buoyancy(rboat, d)
        [CoB, watermass, is_inside_underwater] = calculate_rboat_buoyancy(rboat, d);
        
        res = watermass - rboat.mass; % difference between boat displacement and water displacement
    end
end
