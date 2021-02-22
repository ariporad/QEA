function offset = calculate_eq(r, h, phi, theta)
    phi = phi
    [centerOfMass_global, contact_global, centerOfMass_local, contact_local] = calculate_duckie(r, h, phi, theta)
    offset = contact_global(1) - centerOfMass_global(1)
end

