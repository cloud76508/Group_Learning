clear all
clc

images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');
 
%display_network(images(:,1:100)); % Show the first 100 images
%disp(labels(1:10));

%extract digit images/labels
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


%creat positive segments 
for n = 1:1000   
    tempRandom = randperm(size(Image5,2));
    tempImages = Image5(:, tempRandom(1));
    segment = tempImages;
    segment = reshape(segment,[28,28]);
    
    %saveSeg = sprintf('C:\\Users\\User\\Desktop\\digit_segment\\small_matrix\\positive\\segment%d.mat',n);
    saveSeg = sprintf('C:\\Users\\ASUS\\Desktop\\digit\\positive\\segment%d.mat',n);
    save(saveSeg,'segment')
end

%creat negative segments 
for n = 1:1000
    tempRandom = randperm(size(Image8,2));
    tempImages = Image8(:, tempRandom(1));
    segment = tempImages;
    segment = reshape(segment,[28,28]);
    
    saveSeg = sprintf('C:\\Users\\ASUS\\Desktop\\digit\\negative\\segment%d.mat',n);
    save(saveSeg,'segment')
end

%display_network(reshape(segment,[],1))


