clear all
clc

images1 = loadMNISTImages('train-images.idx3-ubyte');
labels1 = loadMNISTLabels('train-labels.idx1-ubyte');

images2 = loadMNISTImages('t10k-images.idx3-ubyte');
labels2 = loadMNISTLabels('t10k-labels.idx1-ubyte');

images_five = [images1(:,labels1==5), images2(:,labels2==5)];
images_eight = [images1(:,labels1==8), images2(:,labels2==8)];

labels_five = 5*ones(size(images_five,2),1);
labels_eight = 8*ones(size(images_eight,2),1);

%test = reshape(images_five(:,6), [28,28]);
%test = reshape(images_eight(:,1515), [28,28]);
%imshow(test);

clearvars -except images_five images_eight labels_five labels_eight