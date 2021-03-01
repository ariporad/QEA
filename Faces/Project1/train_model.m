%% Train a Model
% Using the images in `imgs` (already as row vectors) and the labels in
% `labels`, generate and return a model with `num_eigenvectors` eigenvectors. 
function model = train_model(imgs, labels, num_eigenvectors)
    %% Image Preprocessing
    imgs = imgs - mean(mean(imgs));
    
    %% PCA
    imgs_cov = cov(imgs);
    [eigenvectors, eigenvalues] = eigs(imgs_cov, num_eigenvectors);
    
    %% Model Packaging
    model.eigenvectors = eigenvectors;
    model.eigenvalues = eigenvalues;
    model.training_imgs = imgs;
    model.training_imgs_projected = eigenvectors' * imgs';
    model.training_labels = labels;
end