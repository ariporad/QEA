%% Helper to collect LIDAR scans from a set of positions and save the
% resulting data to a file.

% The file has a lidar_results matrix which is n x 2 x m, where each
% (:, :, m) is one scan in the form of [r, theta], where r and theta are
% column vectors. It also has a lidar_positions 3 x m matrix of column
% vectors of the format [x, y, phi] (this is the same as the
% `lidar_positions` input argument).

function lidar_results = collectScans(lidar_positions, filename)
    sub = rossubscriber('/scan');
    
    % setup
    num_scans = size(lidar_positions, 1);
    lidar_results = NaN(360, 2, num_scans);
    
    for scan_idx=1:num_scans
        % place Neato at the appropriate point
        angle = lidar_positions(scan_idx, 3);
        placeNeato(lidar_positions(scan_idx, 1), lidar_positions(scan_idx, 2), cos(angle), sin(angle))

        % wait a while for the Neato to fall into place
        pause(2);

        % then collect data for the second location
        scan_message = receive(sub);
        
        % store it appropriately
        lidar_results(:, 1, scan_idx) = scan_message.Ranges(1:end-1);
        lidar_results(:, 2, scan_idx) = deg2rad([0:359]');
    end
    
    % save the data if we were given a filename
    if nargin >= 2
        save(filename, "lidar_results", "lidar_positions");
    end
end