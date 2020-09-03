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


%creat positive segments [7,2,8,6;7,2,8,6;7,2,8,6;7,2,8,6]
for n = 1:1000
    segment = [];
    
    tempRandom = randperm(size(Image8,2));
    segment = Image8(:, tempRandom(1));
    
%     % shift the digit
%     temp = reshape(segment,[28,28]);
%     temp_window = temp(6:22,6:22);  
%     temp = zeros(28,28);
%     r1 = randperm(12);
%     r2 = randperm(12);
%     temp(r1(1):r1(1)+16,r2(1):r2(1)+16) = temp_window;
%     segment = reshape(temp,[],1);
    
    % shift the digit in a large matrix
    temp = reshape(segment,[28,28]);
    temp_window = temp;
    r1 = randperm(28);
    r2 = randperm(28);
%     r1 = 14;
%     r2 = 14;
    temp = zeros(56,56);
    temp(r1(1):r1(1)+27,r2(1):r2(1)+27) = temp_window;
    segment = reshape(temp,[],1);
    
    saveSeg = sprintf('C:\\Users\\User\\Desktop\\digit_segment\\small_matrix\\positive\\segment%d.mat',n);
    save(saveSeg,'segment')
end

%creat negative segments [1,2,3,4;1,2,3,4;1,2,3,4;1,2,3,4]
for n = 1:1000
    segment = [];
    
    tempRandom = randperm(size(Image6,2));
    segment = Image6(:, tempRandom(1));
    
%     % shift the digit
%     temp = reshape(segment,[28,28]);
%     temp_window = temp(6:22,6:22);  
%     temp = zeros(28,28);
%     r1 = randperm(12);
%     r2 = randperm(12);
%     temp(r1(1):r1(1)+16,r2(1):r2(1)+16) = temp_window;
%     segment = reshape(temp,[],1);

    % shift the digit in a large matrix
    temp = reshape(segment,[28,28]);
    temp_window = temp;
    r1 = randperm(28);
    r2 = randperm(28);
%     r1 = 14;
%     r2 = 14;
    temp = zeros(56,56);
    temp(r1(1):r1(1)+27,r2(1):r2(1)+27) = temp_window;
    segment = reshape(temp,[],1);
    
    saveSeg = sprintf('C:\\Users\\User\\Desktop\\digit_segment\\small_matrix\\negative\\segment%d.mat',n);
    save(saveSeg,'segment')
end

%display_network(reshape(segment,[],1))


