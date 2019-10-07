clear all
clc

% Change the filenames if you've saved the files under different names
% On some platforms, the files might be saved as 
% train-images.idx3-ubyte / train-labels.idx1-ubyte
images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');
 
% We are using display_network from the autoencoder code
%display_network(images(:,1:100)); % Show the first 100 images
%disp(labels(1:10));

evenEvent = [0, 2, 4, 6, 8];
oddEvent = [1, 3, 5, 7,9];

%extract even digit images/labels
evenImages = [];
evenLabels = [];
for n = 1:length(evenEvent)
    tempImages = images(:,labels==evenEvent(n));
    tempLabels = zeros(size(tempImages,2),1) + evenEvent(n);
    evenImages = [evenImages,tempImages];
    evenLabels = [evenLabels; tempLabels];
end

randomOrder = randperm(length(evenLabels));
evenImages = evenImages(:,randomOrder);
evenLabels = evenLabels(randomOrder,1);

%extract number one digit images/labels
oneImages = images(:,labels==1);
oneLabels = ones(size(oneImages,2),1);

%creat positive/negative segments (300:1000)
n = 1;
while n <= 600
    segment = [];
    randomOrder1 = randperm(10000);
    randomOrder2 = randperm(3000);
    segment = [evenImages(:,randomOrder1(1:720)), oneImages(:,randomOrder2(1:80))];
    digitLabel = [evenLabels(randomOrder1(1:720),1); oneLabels(randomOrder2(1:80),1)];
    
    randomOrder3 = randperm(length(digitLabel));
    segment = segment(:,randomOrder3);
    digitLabel = digitLabel(randomOrder3,1);
    
    saveSeg = sprintf('C:\\Users\\User\\Desktop\\IJCNN\\digit\\positive\\V1\\segment%d.mat',n);
    saveLab = sprintf('C:\\Users\\User\\Desktop\\IJCNN\\digit\\positive\\V1\\label%d.mat',n);
    save(saveSeg,'segment')
    save(saveLab,'digitLabel')
    n = n+1;
end

n = 1;
while n <= 600
    segment = [];
    randomOrder1 = randperm(19000)+10000;
    randomOrder2 = randperm(3000)+3000;
    
    segment = evenImages(:,randomOrder1(1:800));
    digitLabel = evenLabels(randomOrder1(1:800),1);
%     segment = [evenImages(:,randomOrder1(1:760)), oneImages(:,randomOrder2(1:40))];
%     digitLabel = [evenLabels(randomOrder1(1:760),1); oneLabels(randomOrder2(1:40),1)];
%     
%     randomOrder3 = randperm(length(digitLabel));
%     segment = segment(:,randomOrder3);
%     digitLabel = digitLabel(randomOrder3,1);
    
    saveSeg = sprintf('C:\\Users\\User\\Desktop\\IJCNN\\digit\\negative\\V1\\segment%d.mat',n);
    saveLab = sprintf('C:\\Users\\User\\Desktop\\IJCNN\\digit\\negative\\V1\\label%d.mat',n);
    save(saveSeg,'segment')
    save(saveLab,'digitLabel')
    n = n+1;
end
