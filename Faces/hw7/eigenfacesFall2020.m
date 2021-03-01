eigenfaces2020()

function accuracy = eigenfaces2020(numPrincipalComponents, useOnlyNoSmileForTraining, showEigenFaces)
% handy trick to set a default values for our arguments
if nargin < 1
    numPrincipalComponents = 10;
end
if nargin < 2
    % this is true to use the data in part 7
    useOnlyNoSmileForTraining = false;
end
if nargin < 3
    showEigenFaces = false;
end

if ~useOnlyNoSmileForTraining
    load('classdata_train.mat');
    load('classdata_test.mat');
else
    load('classdata_no_smile.mat');
    load('classdata_smile.mat');
end

ATrain = reshape(grayfaces_train, [size(grayfaces_train,1)*size(grayfaces_train,2), size(grayfaces_train,3)])';
ATest = reshape(grayfaces_test, [size(grayfaces_test,1)*size(grayfaces_test,2), size(grayfaces_test,3)])';

disp("ATrainSize")
size(ATrain)

% mean center the train and test data
ATrain = ATrain - mean(ATrain);
ATest = ATest - mean(ATest);

% get covariance matrix of the training data
covar = ATrain'*ATrain;

% get EVD (so we can do PCA)
% If you want all of the Eigenvectors / Eigenvalue, you can use eig:
% [Q, Delta] = eig(covar);

% if you wan to just get the eigenvectors swith largest eigenvalues
% you can use eigs.
[Q, Delta] = eigs(covar, numPrincipalComponents);




if showEigenFaces
    % visualize the principal components as images
    f = figure;
    for i = 1 : numPrincipalComponents
        subplot(ceil(sqrt(numPrincipalComponents)), ceil(sqrt(numPrincipalComponents)), i);
        imagesc(reshape(Q(:,i), [64 64]));  % TODO: remove hardcoding
        colormap('gray');
        % make the axes have equal length and square
        axis equal 
        axis square
    end

end

% project into face space
faceSpaceTrain = Q'*ATrain';
faceSpaceTest = Q'*ATest';




% go through each image in the test set and find its 
% Eucledian distance from each face in the train set, all in face space
% Find the nearest image in the train set to each test image

num_images_test = size(faceSpaceTest, 2);  
num_images_train = size(faceSpaceTrain, 2); 
% pre-create vectors to store distances between the k-th test face and all
% the training faces, and a vector which stores the index of the 
% nearest-neigbor. NaN is a MATLAB command which creates an array of NaN
% (not a numbers) with specified dimensions. 
distances_in_face_space = NaN(num_images_train, 1); 
NN = NaN(num_images_test,1);

for k=1:num_images_test  % loop through all the test images
    for n = 1:num_images_train % loop through all the training images
        
        % calculte the distance between the k-th face in the test set to the n-th face
        % in the training set and store the distances
        % note that faceSpaceTest and faceSpaceTrain are 2-D arrays
        % and sum sums along the columns, so we sum twice
        distances_in_face_space(n) = sqrt(sum(sum((faceSpaceTest(:,k)-faceSpaceTrain(:,n)).^2)));
    
    end
    % find the minimum of the distances between the kth test face and all the
    % training faces
    [tmp, idx] = min(distances_in_face_space);
    % assign the index corresponding to the nearesest image in the training
    % set as the nearest neighbor to the kth image
    NN(k) = idx;
end


% Instead of looping through each test image and each training image, in
% the previous block of code, you can use MATLAB's knnsearch function
% which does the same thing instead
% we've commented this out here 
% NN = knnsearch(faceSpaceTrain', faceSpaceTest');


% let's check to see if the subject corresponding to the second closest
% photo is the same as the one corresponding to the query image
    accuracy = mean(subject_train(NN)==subject_test);

    disp("Size Q")
    size(Q)

end