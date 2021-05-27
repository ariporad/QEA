function drive_bod()
    %% Configuration
    % alpha is a linear scalar with time, and controls the speed of the robot
    % It's been approximately calibrated to keep the robot's maximum speed
    % below the limit of 2 m/s
    alpha = 1/5;

    % d is the wheelbase of the robot
    d = 0.235; % m

    % The range of u is specified by the definition of the Bridge of Doom (dun
    % dun dun)
    U_RANGE = [0 3.2];

    % We also convert the range of u into a range of t (u and t are linearly
    % correlated) for convinence
    T_RANGE = U_RANGE ./ alpha;

    % This loads the equations from the cannonical equations.m file, which we
    % use to ensure that this script and the main live script have exactly the
    % same equations, in line with the programming principle of DRY (Don't
    % Repeat Yourself).
    equations;

    % This is the format of the messages we send to the Neato. By packing it
    % into a vector here and converting that from a symbolic value into a
    % matlab function, it becomes much much faster to send commands to the
    % Neato, which increases accuracy.
    msgData = [v_l, v_r];

    % generateMessageData(t) now returns a vector with the right v_l and v_r,
    % without using the Symbolic Toolbox
    generateMessageData = matlabFunction(msgData);

    %% Connect to the Neato 
    disp("Connecting to Neato...")
    pub = rospublisher('raw_vel');

    %% Setup the Neato
    disp("Stopping Neato...")

    % stop the robot if it's going right now
    stopMsg = rosmessage(pub);
    stopMsg.Data = [0 0];
    send(pub, stopMsg);

    disp("Resetting Neato...")

    bridgeStart = double(subs(r,t,0));
    startingThat = double(subs(T_hat,t,0));
    placeNeato(bridgeStart(1),  bridgeStart(2), startingThat(1), startingThat(2));

    % HACK: Wait a bit for robot to fall onto the bridge
    pause(2);

    %% Drive
    disp("Starting to Drive...")

    % Keep track of when we started so we can calculate t 
    rostic;

    while 1 % We'll break out of the loop manually
        % Get the current time
        cur_t = rostoc;

        % If we've hit the end, stop the robot and exit the loop
        if cur_t >= T_RANGE(2)
            stopMsg = rosmessage(pub);
            stopMsg.Data = [0 0];
            send(pub, stopMsg);
            break
        end

        % Otherwise, calculate the speed the Neato should be at and tell it to
        % go at that speed
        speedMsg = rosmessage(pub);
        speedMsg.Data = generateMessageData(cur_t);
        send(pub, speedMsg);
    end

    disp("Done!")
end