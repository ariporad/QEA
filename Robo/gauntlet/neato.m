%% Neato Runner
% This is a simple script for the neato that simply takes a set of timed
% wheel velocities and exeuctes them. It's very dumb so that all of the
% smarts can be calculated ahead of time, which drastically improves
% performance.
function neato(datafile)
    %% Configuration
    % Load pre-computed points
    % NOTE: msgs and ts must be sorted!
    if nargin < 1
        datafile = "drivedata.mat";
    end
    load(datafile, "startPos", "startHead", "ts", "msgs")

    %% Connect to the Neato 
    disp("Connecting to Neato...")
    pub = rospublisher('raw_vel');
    bumpsub = rossubscriber('bump');

    %% Setup the Neato
    disp("Stopping Neato...")

    % stop the robot if it's going right now
    stopMsg = rosmessage(pub);
    stopMsg.Data = [0 0];
    send(pub, stopMsg);

    disp("Resetting Neato...")

    placeNeato(startPos(1), startPos(2), startHead(1), startHead(2));

    % HACK: Wait a bit for robot to fall to the ground
    pause(2);

    %% Drive
    disp("Starting to Drive...")

    % Keep track of when we started so we can calculate t 
    rostic;
    
    i = 0;
    
    num_msgs = length(msgs);

    while 1 % We'll break out of the loop manually
        % Get the current time
        cur_t = rostoc;
        
        if ts(i + 1) <= cur_t
            i = i + 1;
            
            fprintf("[t: %2.2f] Sending message #%1.0f: [%2.2f, %2.2f]\n", cur_t, i, msgs(i, 1), msgs(i, 2))
           
            speedMsg = rosmessage(pub);
            speedMsg.Data = msgs(i, :);
            send(pub, speedMsg);
        end
        
        bumpmsg = receive(bumpsub);
        
        if any(bumpmsg.Data)
            disp("Hit Something! Stopping!")
            break
        end
        
        if i == num_msgs
            break
        end
    end
    
    stopMsg = rosmessage(pub);
    stopMsg.Data = [0 0];
    send(pub, stopMsg);

    disp("Done!")
end