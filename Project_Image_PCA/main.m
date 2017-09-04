%% 1. First read in the given set of images
%% 2. Compute PCA and reconstruct the image after reducing dimension to K=10
%% 3. Compute LDA on the projections from PCA reduced image
%% 4. Plot the decision boundary
%% 5. Calclate the optimal value of K

function [MSE_Image] = main(fileName)


class = [ 0, 0, 1,1,0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1,1, 0, 1, 0, 1];

input_Image = loadImage();

%%% Calculate PCA for each of the images 
%%% Reconstruct and plot the images for K=10
MSE_Image = zeros(1, size(input_Image,1));


%%% Read in the given test image
test_img = imread(fileName);
image_vector = reshape(test_img,1 , prod(size(test_img)));
img_mean_rem = double(image_vector - mean(image_vector));

%%% Calculate PCA on the training set of images
[eigvals, eigvectors, PSNR, Recon_image] = PCA(input_Image, 10, 1);

%%% Calculate the projections on the given eignevectors
Proj = eigvectors'*img_mean_rem';

%%% Calculate LDA on the PCA reduced eignevectors
[Xproj, eigvec, lambda] = lda(input_Image, eigvectors, class);

%%% Calculate the projection on the eignevector
Xm = bsxfun(@minus, Proj, mean(Proj));
Xproj = Xm'*eigvec;

%%%% Classify
printf("Projection in LDA space is %d\n", Xproj);
if(Xproj > 0 ) 
  disp("Happy Face");
else
  disp("Sad face"); 
end
