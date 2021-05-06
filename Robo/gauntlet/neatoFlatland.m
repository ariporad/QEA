function positions = neatoFlatland(delta, lambda0, r0, heading, tolerance, n_max, ...
    linear_speed, angular_speed)

[f, Z] = gauntletPotentialField();

grad = matlabFunction(gradient(Z));
position = r0;
lambda = lambda0;
positions = r0';
n = 0;

wheel_distance = 0.235;

% connect to the neato
pub = rospublisher('/raw_vel');
msg = rosmessage(pub);
% stop the neato
msg.Data = [0, 0];
send(pub, msg);
pause(2);

% put the neato in the starting position
placeNeato(position(1), position(2), heading(1), heading(2));
% wait bc the sim is slow
pause(2);

% start ascent
tolerance_reached = false;
while ~tolerance_reached && n < n_max
    disp("LOOOOOP")
    current_grad = grad(position(1), position(2));
    
    % calculate angle and turn
    turn_angle = double(atan2(norm(cross([current_grad;0],[heading;0])),...
        dot([current_grad;0],[heading;0])));
    turn_direction = sign(turn_angle);
    turn_time = turn_angle / angular_speed;
    
    msg.Data = [-turn_direction*angular_speed*wheel_distance/2,
                turn_direction*angular_speed*wheel_distance/2];
    % start rotating, stop when enough time has passed
    send(pub, msg);
    
    start_turn = rostic;
    while rostoc(start_turn) < turn_time
        disp("TURN PAUSE")
        pause(0.01);
    end
    heading = current_grad;
    
    % calculate the new position, figure out how far to move
    new_pos = position + lambda .* current_grad;
    positions(end+1,:) = new_pos';
    distance = norm(new_pos - position);
    
    move_time = distance/linear_speed;
    msg.Data = [linear_speed, linear_speed];
    % start moving, stop when enough time has passed 
    send(pub, msg);
    
    start_move = rostic;
    while rostoc(start_move) < move_time
        disp("PAUSED");
        pause(0.01);
    end
    position = new_pos
    
    n = n+1;
    lambda = lambda*delta;
    tolerance_reached = distance < tolerance;
end

% stop neato
msg.Data = [0, 0];
send(pub, msg);
end