function drive_bod()
% Insert any setup code you want to run here
equations

pub = rospublisher('raw_vel');

% stop the robot if it's going right now
stopMsg = rosmessage(pub);
stopMsg.Data = [0 0];
send(pub, stopMsg);

bridgeStart = double(subs(R,t,0));
startingThat = double(subs(That,t,0));
placeNeato(bridgeStart(1),  bridgeStart(2), startingThat(1), startingThat(2));

% wait a bit for robot to fall onto the bridge
pause(2);

% time to drive!!

rostic;

while 1
    cur_t = rostoc;
    
    if cur_t > T_RANGE(2)
        break
    end
    
    speedMsg = rosmessage(pub);
    % TODO: Convert this to use matlabFunction ahead of time
    % TODO: Could we pack these into a vector ahead of time?
    speedMsg.Data = [double(subs(v_l, t, cur_t)), double(subs(v_r, t, cur_t))]
end

end