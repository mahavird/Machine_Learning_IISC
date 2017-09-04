% calculate the reduced deimension representation of the N images


function [Xproj, eigvec, lambda] = lda(X, eigvectors, class)

mean_vec = mean(X');
mean_mat = mean_vec'*ones(1,columns(X));
R = double(X - mean_mat); % Mean removed image

for i=1:size(X,1)
  Proj(i,:) = eigvectors'*R(i, :)';
end
Mean_Class0 = Mean_Class1 = zeros(1,size(Proj,2));

num_class0 = num_class1 = 0;
for i=1:size(X,1)
  if(class(i) == 0) %% Happy
     Mean_Class0 += Proj(i, :);
     num_class0 +=1;
  else 
     Mean_Class1 += Proj(i,:);
     num_class1 +=1;
  end
end

Mean_Total = mean(Proj);
if(num_class0 != 0)
  Mean_Class0 = Mean_Class0 ./ num_class0;
end
if(num_class1 != 0)
  Mean_Class1 = Mean_Class1 ./ num_class1;
end
Scatter_W = zeros(size(Proj,2), size(Proj,2));
Scatter_B = zeros(size(Proj,2), size(Proj,2));

%%% Compute the Within Class Scatter Matrix S_W
test = test1 = zeros(size(X,1), size(Proj,2));
for i=1:size(X,1)
  if(class(i) == 0) 
    test = double(Proj(i,:) - Mean_Class0);
  else
    test1 = double(Proj(i,:) - Mean_Class1);
end
end
Scatter_W = test*test' + test1*test1';

%%% Compute the Across Class Scatter Matrix
op1 = double(Mean_Class0 - Mean_Total);
op2 = double(Mean_Class1 - Mean_Total);
Scatter_B = 2*(op1'*op1 + op2'*op2); 
Cov_matrix = Scatter_B/Scatter_W;

%%% Calculate the principal eigenvalue of S_W^-1 S_B
[eigvec, lambda] = eigs(Cov_matrix,1);

%%% Calculate the projection on the eignevector
Xm = bsxfun(@minus, Proj, mean(Proj));
Xproj = Xm*eigvec;
class0 = Xproj(find(class==0),:);
class1 = Xproj(find(class==1),:);

%%% Plot the figure of the two classes post LDA
axis("tight")
figure;
plot(class0,"go", "markersize", 10, "linewidth", 3);
hold on;
plot(class1,"ro", "markersize", 10, "linewidth", 3);
title("Class separation after LDA, Green = Happy, Red = Sad");
hold off;
end
