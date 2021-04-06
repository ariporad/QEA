function drive_bod()

% Insert any setup code you want to run here
%% Robot Config
alpha = 1/5;
d = 0.235; % m
U_RANGE = [0 3.2];
T_RANGE = U_RANGE ./ alpha;
% N = 50;
% 
% us = linspace(U_RANGE(1), U_RANGE(2), N)';
% ts = us ./ alpha;
equations
msgData = [v_l, v_r];
generateMessageData = matlabFunction(msgData);

disp("Connecting to Neato...")

pub = rospublisher('raw_vel');

disp("Stopping Neato...")

% stop the robot if it's going right now
stopMsg = rosmessage(pub);
stopMsg.Data = [0 0];
send(pub, stopMsg);

disp("Resetting Neato...")

bridgeStart = double(subs(r,t,0));
startingThat = double(subs(T_hat,t,0));
placeNeato(bridgeStart(1),  bridgeStart(2), startingThat(1), startingThat(2));

% wait a bit for robot to fall onto the bridge
pause(2);

disp("Starting to Drive...")

% time to drive!!
rostic;

while 1
    cur_t = rostoc;
    
    if cur_t >= T_RANGE(2)
        stopMsg = rosmessage(pub);
        stopMsg.Data = [0 0];
        send(pub, stopMsg);
        break
    end
    
    speedMsg = rosmessage(pub);
    speedMsg.Data = generateMessageData(cur_t);
    send(pub, speedMsg);
end

disp("Done!")

end