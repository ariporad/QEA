%% Recognize an image using a pre-trained model
% This function accepts a model and an image, then projects the image onto
% the model's eigenvectors and finds its nearest neighbor, returning the
% label and the match index.
function [label, match] = recognize(model, img)
    %% Image Preprocessing
    % The nice thing about reshaping here is that it works even if the
    % image has already been reshaped.
    img = reshape(img, [size(img, 1) * size(img, 2), 1]);
    
    %% Image/Eigenvector Projection
    img_projected = model.eigenvectors' * img;
    
    %% Matching and Labeling
    match = knnsearch(model.training_imgs_projected', img_projected');
    label = model.training_labels(match);
end