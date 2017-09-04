function [eigvals, eigvectors, PSNR, Recon_image] = PCA(X, K, Img_id)
% Given a NxD image where N is the no. of training images
% D is the dimension of each image.
% This function calcultes the NxN covariance matrix and its
% eigenvalues u. These are used to find the eigenvectors of
% the desired DxD image matrix.
% The N eigenvectors are reduced to the desired dimension K.
% The images are reconstructed using K eigenvectors and the
% reduced representation of w_k, where k= 1...K are returned
% along with the eignevectors.
% Inputs:
%   X -- NxD image matrix of training set
%   K -- No. of eignevectors to compute (1 - 20)
%   Img_id --- Training set image id for reconstruction
% Outputs:
%   eigvals - Eigenvalues (in decreasing order of magnitude)
%   eigvectors - Eigenvectors corresponding to eigenvalues
%   PSNR -- PSNR of reconstructed image
%   Recon_image --- Reconstructed image as 1XD vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Construct the covariance matrix of XX' and 
%% Compute the N x N eignevectors
mean_vec = mean(X');
mean_mat = mean_vec'*ones(1,columns(X));
R = double(X - mean_mat); % Mean removed image
cov_XX = (R*R')/rows(X);
[eigvec, lambda] = eigs(cov_XX, K);
%% Transform into D x N eignevector space
eigvectors = R'*eigvec;
%%% Calculate the projections for each image
eigvals = sort(diag(lambda), 'descend')(1:K)
%% Normalize the eigvals and eigvectors


eigvals = eigvals/size(X,1);
eigvals = eigvals/max(eigvals);

for i=1:K
  eigvectors(:,i) = eigvectors(:,i)/norm(eigvectors(:,i));
end

%% Image Reconstruction using K eigvectors
Proj = eigvectors'*R(Img_id, :)';
Recon_image = eigvectors*Proj + mean_vec(Img_id);
Recon_image1 = reshape(round(Recon_image),101, 101);
%% 
set(gcf, 'colormap',gray);
imagesc(Recon_image1)
title("Reconstructed image with K=10 eigenvectors");
outfile = sprintf("Recon_image%d.gif",Img_id);
%%imwrite(Recon_image1, outfile);
MSE = 0.0;
for i=1:prod(size(Recon_image))
  MSE += double((X(Img_id, i) - Recon_image(i)))^2;
end
PSNR = 10*log10((255^2)/MSE);
printf("PSNR of reconstructed image is %d\n", PSNR); 
end
