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
while n <= 1000
    segment = [];
    randomOrder1 = randperm(10000);
    randomOrder2 = randperm(length(oneLabels));
    segment = [evenImages(:,randomOrder1(1:810)), oneImages(:,randomOrder2(1:90))];
    digitLabel = [evenLabels(randomOrder1(1:810),1); oneLabels(randomOrder2(1:90),1)];
    
    randomOrder3 = randperm(length(digitLabel));
    segment = segment(:,randomOrder3);
    digitLabel = digitLabel(randomOrder3,1);
    
    % reshape segment to 28*30x28*30
    segment_raw = zeros(28*30,28*30);
    i = 0;
    j = 0;
    for m = 1:size(segment,2)
        temp = segment(:,m);
        temp = reshape(temp,[28,28]);
        if j == 30 && i<30
           i = i+1;
           j = 0;
        end
        segment_raw(i*28+1:(i+1)*28,j*28+1:(j+1)*28) = temp;
        j = j+1;
    end
    segment = segment_raw;
     
    saveSeg = sprintf('C:\\Users\\User\\Desktop\\digit_segment\\positive\\segment%d.mat',n);
    saveLab = sprintf('C:\\Users\\User\\Desktop\\digit_segment\\positive\\label%d.mat',n);
    save(saveSeg,'segment')
    save(saveLab,'digitLabel')
    n = n+1;
end

n = 1;
while n <= 1000
    segment = [];
    randomOrder1 = randperm(19000)+10000;
    segment = evenImages(:,randomOrder1(1:900));
    digitLabel = evenLabels(randomOrder1(1:900),1);
    
    % reshape segment to 28*30x28*30
    segment_raw = zeros(28*30,28*30);
    i = 0;
    j = 0;
    for m = 1:size(segment,2)
        temp = segment(:,m);
        temp = reshape(temp,[28,28]);
        if j == 30 && i<30
           i = i+1;
           j = 0;
        end
        segment_raw(i*28+1:(i+1)*28,j*28+1:(j+1)*28) = temp;
        j = j+1;
    end
    segment = segment_raw;
       
    saveSeg = sprintf('C:\\Users\\User\\Desktop\\digit_segment\\negative\\segment%d.mat',n);
    saveLab = sprintf('C:\\Users\\User\\Desktop\\digit_segment\\negative\\label%d.mat',n);
    save(saveSeg,'segment')
    save(saveLab,'digitLabel')
    n = n+1;
end
%display_network(reshape(segment,[],1))