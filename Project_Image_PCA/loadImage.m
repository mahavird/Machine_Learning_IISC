% This function reads all Read 101x101 images provided
% Contruct a NxD vector inp_image_X of size N x D
% where N = 15 and D = 10201



function inp_image_X = loadImage()
%% Read the files and pack into columns
files = [ "subject01.happy.gif"; "subject01.happy.gif";
          "subject02.sad.gif"; "subject03.sad.gif";
          "subject04.happy.gif"; "subject04.sad.gif";
          "subject05.sad.gif"; "subject06.happy.gif";
          "subject06.sad.gif"; "subject07.happy.gif";
          "subject07.sad.gif"; "subject09.happy.gif";
          "subject09.sad.gif"; "subject10.happy.gif";
          "subject10.sad.gif"; "subject11.sad.gif";
          "subject12.happy.gif"; "subject12.sad.gif";
          "subject13.happy.gif"; "subject13.sad.gif"];
       
inp_image_X=[];
for i=1:length(files)
  image_mat = imread(deblank(files(i,:)));
  image_vector = reshape(image_mat,1 , prod(size(image_mat)));
  inp_image_X = [inp_image_X; image_vector];
end

disp( "Size of image matrix is: ");
disp(size(inp_image_X));

end
