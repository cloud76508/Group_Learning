clear all
clc
dir_images = 'D:\CroppedYale\yaleB41\';
imageList = dir(fullfile([dir_images '*.pgm']));
destdirectory = 'C:\Users\ASUS\Desktop\images\yaleB41';
mkdir(destdirectory); 

for n =1:size(imageList,1)
    fimage = [];
    fimage = imread([dir_images imageList(n).name]);
    fimage = fimage(1:160,1:160);
    %temp = rgb2gray(temp);
    fimage = im2double(fimage);
    %temp = reshape(temp, [600*600,1]);
    imageName = sprintf('%s.mat',imageList(n).name(1:end-4));
    fulldestination = fullfile(destdirectory, imageName); 
    
    %saveSeg = sprintf('C:\\Users\\ASUS\\Desktop\\images\\yaleB07\\%s.mat',imageList(n).name(1:end-4));
    save(fulldestination,'fimage')
end




