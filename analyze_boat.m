function rboat = analyze_boat(boat, theta)
    rboat = create_rendered_boat(boat, theta);
    dmin = min(rboat.P(2,:)); % find the minimum z coordinate of the boat
    dmax = max(rboat.P(2,:)); % find the maximum z coordinate of the boat

    rboat.d = fzero(@(d) buoyancy(rboat, d), [dmin,dmax]); % find the waterline d
    
    [rboat.CoB, rboat.watermass, rboat.is_inside_underwater] = calculate_rboat_buoyancy(rboat, rboat.d);

    rboat.moment_arm = rboat.CoB(1, 1) - rboat.CoM(1, 1);

    function res = buoyancy(rboat, d)
        [CoB, watermass, is_inside_underwater] = calculate_rboat_buoyancy(rboat, d);
        
        res = watermass - rboat.mass; % difference between boat displacement and water displacement
    end
end
