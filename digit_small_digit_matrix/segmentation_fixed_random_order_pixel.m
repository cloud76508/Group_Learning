clear all
clc

images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');
%data source: http://yann.lecun.com/exdb/mnist/
%Source: http://ufldl.stanford.edu/wiki/index.php/Using_the_MNIST_Dataset.

 
%display_network(images(:,1:100)); % Show the first 100 images
%disp(labels(1:10));

% fileID = fopen('train-images.idx3-ubyte');
% A = fread(fileID);
% fileLabel = fopen('train-labels.idx1-ubyte');
% B = fread(fileLabel);
%imshow(reshape(segment(:,1),[28,28]))

%extract digit images/labels
Image0 = images(:,labels==0);
Label0 = ones(size(Image0,2),1)-1;
Image1 = images(:,labels==1);
Label1 = ones(size(Image1,2),1);
Image2 = images(:,labels==2);
Label2 = ones(size(Image2,2),1)+1;
Image3 = images(:,labels==3);
Label3 = ones(size(Image3,2),1)+2;
Image4 = images(:,labels==4);
Label4 = ones(size(Image4,2),1)+3;
Image5 = images(:,labels==5);
Label5 = ones(size(Image5,2),1)+4;
Image6 = images(:,labels==6);
Label6 = ones(size(Image6,2),1)+5;
Image7 = images(:,labels==7);
Label7 = ones(size(Image7,2),1)+6;
Image8 = images(:,labels==8);
Label8 = ones(size(Image8,2),1)+7;
Image9 = images(:,labels==9);
Label9 = ones(size(Image9,2),1)+8;

fixed_random = randperm(784*16)';

%creat positive segments [7,2,8,6;7,2,8,6;7,2,8,6;7,2,8,6]
for n = 1:1000
    segment = [];
    
    tempRandom = randperm(size(Image7,2));
    tempImages = [Image7(:, tempRandom(1)), ...
        Image7(:, tempRandom(2)),Image7(:, tempRandom(3)),... 
        Image7(:, tempRandom(4))];
    segment = [segment,tempImages];
    
    tempRandom = randperm(size(Image2,2));
    tempImages = [Image2(:, tempRandom(1)), ...
        Image2(:, tempRandom(2)),Image2(:, tempRandom(3)),... 
        Image2(:, tempRandom(4))];
    segment = [segment,tempImages];
    
    tempRandom = randperm(size(Image8,2));
    tempImages = [Image8(:, tempRandom(1)), ...
        Image8(:, tempRandom(2)),Image8(:, tempRandom(3)),... 
        Image8(:, tempRandom(4))];
    segment = [segment,tempImages];
    
    tempRandom = randperm(size(Image6,2));
    tempImages = [Image6(:, tempRandom(1)), ...
        Image6(:, tempRandom(2)),Image6(:, tempRandom(3)),... 
        Image6(:, tempRandom(4))];
    segment = [segment,tempImages];
    
    %random permute pixels for whole digit-matrix
    Origin_segment = segment;
    temp_segment = reshape(segment, [],1);
    temp_segment = temp_segment(fixed_random); %permute the pixel using fixed random order
    segment = reshape(temp_segment, size(segment,1),size(segment,2));
   
    saveSeg = sprintf('C:\\Users\\User\\Desktop\\digit_segment\\small_matrix\\positive\\segment%d.mat',n);
    save(saveSeg,'segment')
end

%creat negative segments [1,2,3,4;1,2,3,4;1,2,3,4;1,2,3,4]
for n = 1:1000
    segment = [];
    
    tempRandom = randperm(size(Image1,2));
    tempImages = [Image1(:, tempRandom(1)), ...
        Image1(:, tempRandom(2)),Image1(:, tempRandom(3)),... 
        Image1(:, tempRandom(4))];
    segment = [segment,tempImages];
    
    tempRandom = randperm(size(Image2,2));
    tempImages = [Image2(:, tempRandom(1)), ...
        Image2(:, tempRandom(2)),Image2(:, tempRandom(3)),... 
        Image2(:, tempRandom(4))];
    segment = [segment,tempImages];
    
    tempRandom = randperm(size(Image3,2));
    tempImages = [Image3(:, tempRandom(1)), ...
        Image3(:, tempRandom(2)),Image3(:, tempRandom(3)),... 
        Image3(:, tempRandom(4))];
    segment = [segment,tempImages];
    
    tempRandom = randperm(size(Image4,2));
    tempImages = [Image4(:, tempRandom(1)), ...
        Image4(:, tempRandom(2)),Image4(:, tempRandom(3)),... 
        Image4(:, tempRandom(4))];
    segment = [segment,tempImages];
    
    %random permute pixels for whole digit-matrix
    Origin_segment = segment;
    temp_segment = reshape(segment, [],1);
    temp_segment = temp_segment(fixed_random); %permute the pixel using fixed random order
    segment = reshape(temp_segment, size(segment,1),size(segment,2));
    
    saveSeg = sprintf('C:\\Users\\User\\Desktop\\digit_segment\\small_matrix\\negative\\segment%d.mat',n);
    save(saveSeg,'segment')
end




