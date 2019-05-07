function [train, val, test, train_patch,val_patch,test_patch] = loadData_KNN(sizeRatio)

%sizeRatio = 1;

% Change the filenames if you've saved the files under different names
% On some platforms, the files might be saved as 
% train-images.idx3-ubyte / train-labels.idx1-ubyte
images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');
 
% We are using display_network from the autoencoder code
%display_network(images(:,1:100)); % Show the first 100 images
%disp(labels(1:10));

%extract eight digit images/labels (+)
eightImages = images(:,labels==8);
randomOrder1 = randperm(size(eightImages,2));
eightImages = eightImages(:,randomOrder1);
eightLabels = ones(size(eightImages,2),1) + 7;
eightImages = eightImages';

%extract five digit images/labels (-)
fiveImages = images(:,labels==5);
randomOrder2 = randperm(size(fiveImages,2));
fiveImages = fiveImages(:,randomOrder2);
fiveLabels = ones(size(fiveImages,2),1)+4;
fiveImages = fiveImages';

train.x = [eightImages(1:5*sizeRatio,:);fiveImages(1:5*sizeRatio,:)];
train.y = [ones(5*sizeRatio,1); zeros(5*sizeRatio,1)];

val.x = [eightImages(1000:1000+5*2*sizeRatio-1,:);fiveImages(1000:1000+5*2*sizeRatio-1,:)];
val.y = [ones(5*2*sizeRatio,1); zeros(5*2*sizeRatio,1)];

test.x = [eightImages(2001:2250,:);fiveImages(2001:2250,:)];
test.y = [ones(250,1); zeros(250,1)];

%generate the training patch data
train_patch.x = [];
train_patch.y = [];
for n =1:size(train.x,1)
    temp = train.x(n,:);
    temp1 = [];
    temp2 = [];
    i = 0;
    while i<28
        temp1 = [temp1,temp(1,1+i*28:14+i*28)];
        temp2 = [temp2,temp(1,15+i*28:28+i*28)];
        i = i+1;
    end
    temp11 = temp1(1:196);
    temp12 = temp1(197:end);
    temp21 = temp2(1:196);
    temp22 = temp2(197:end);
    
    train_patch.x = [train_patch.x; temp11; temp12;temp21;temp22];
end

train_patch.y = [ones(size(train_patch.x,1)/2,1);zeros(size(train_patch.x,1)/2,1)];

%generate the validation patch data
val_patch.x = [];
val_patch.y = [];
for n =1:size(val.x,1)
    temp = val.x(n,:);
    temp1 = [];
    temp2 = [];
    i = 0;
    while i<28
        temp1 = [temp1,temp(1,1+i*28:14+i*28)];
        temp2 = [temp2,temp(1,15+i*28:28+i*28)];
        i = i+1;
    end
    temp11 = temp1(1:196);
    temp12 = temp1(197:end);
    temp21 = temp2(1:196);
    temp22 = temp2(197:end);
    
    val_patch.x = [val_patch.x; temp11; temp12;temp21;temp22];
end

val_patch.y = [ones(size(val_patch.x,1)/2,1);zeros(size(val_patch.x,1)/2,1)];


%generate the validation patch data
test_patch.x = [];
test_patch.y = [];
for n =1:size(test.x,1)
    temp = test.x(n,:);
    temp1 = [];
    temp2 = [];
    i = 0;
    while i<28
        temp1 = [temp1,temp(1,1+i*28:14+i*28)];
        temp2 = [temp2,temp(1,15+i*28:28+i*28)];
        i = i+1;
    end
    temp11 = temp1(1:196);
    temp12 = temp1(197:end);
    temp21 = temp2(1:196);
    temp22 = temp2(197:end);
    
    test_patch.x = [test_patch.x; temp11; temp12;temp21;temp22];
end

test_patch.y = [ones(size(test_patch.x,1)/2,1);zeros(size(test_patch.x,1)/2,1)];



