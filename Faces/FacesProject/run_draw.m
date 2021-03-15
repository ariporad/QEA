%% Run the entire PCA process
% This function is a wrapper over the entire recognition process (not
% including training). It accepts a trained model, then prompts the user to
% draw a symbol, rasterizes it, projects it onto the eigenvectors, and
% finds the nearest neighbor.
function [label, match] = run_draw(model)
	%% Drawing
    points = draw("Draw a Mathematical Character or Symbol:");
	
    %% Rasterization
    img = rasterize(points, 45);

    %% Sanity Check: Display Rasterized Image
	figure; 
    imshow(img);
    title("You drew:");
    
    %% Character Recognition
	[label, match] = recognize(model, img);

    %% Output
    title(sprintf("You drew a %s (#%1.0f):", label, match));
	fprintf("You drew a %s (#%1.0f)!\n", label, match);
end