function [centerOfMass_global, contact_global, centerOfMass_local, contact_local, P] = calculate_duckie(r, h, phi, theta)
    [centerOfMass_local, ~, P] = simulate_duckie(@predicate);
    
    contact_local = [r * tand(phi); 0];
    
    R_ramp = rotation_matrix(-theta)
    centerOfMass_global = R_ramp * centerOfMass_local;
    contact_global = R_ramp * contact_local;
    
    
    function is_in_duckie = predicate(P)
        X = P(1, :);
        Y = P(2, :);
        
        lower_bound = Y >= (r - sqrt(r.^2 - (X - (r * tand(phi))).^2));
        upper_bound = Y <= h;
        
        is_in_duckie = lower_bound & upper_bound;
    end
end
