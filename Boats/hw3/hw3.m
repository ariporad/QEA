h = 3;
r = 6;
theta = 10;

phi = fzero(@(phi) calculate_eq(r, h, phi, theta), 0)

% phis = linspace(0, 10, 100);
% errs = zeros(100);

% for i=1:100
% 	errs(i) = calculate_eq(r, h, phis(i), theta);
% end

% figure;
% plot(phis, errs);




% calculate_eq(r, h, 0, theta)

%[centerOfMass_global, contact_global, centerOfMass_local, contact_local, ~] = calculate_duckie(r, h, 0, theta)

%  clf; scatter(P(1, :), P(2, :), 'k.'); axis equal; hold on;
%  plot(centerOfMass_local(1), centerOfMass_local(2), "r+");
%  plot(contact_local(1), contact_local(2), "g+");
%  legend("Boat", "Center of Mass", "Contact Point")  
