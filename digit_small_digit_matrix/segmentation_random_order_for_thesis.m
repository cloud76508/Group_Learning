clear all
clc

images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');
 
%display_network(images(:,1:100)); % Show the first 100 images
%disp(labels(1:10));

%extract digit images/labels
Image0 = images(:,labels==0);
Label0 = ones(size(Image0,2),1);
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

even_Image = [Image0,Image2,Image4,Image6,Image8];
odd_Image = [Image1,Image3,Image5,Image7,Image9];


%creat positive segments 
for n = 1:1000
    segment = [];
    
    tempRandom = randperm(size(odd_Image,2));
    
    tempImages = [];
    for m = 1:4
        tempImages = [tempImages, odd_Image(:, tempRandom(m))];
    end
    segment = [segment,tempImages];
%    %---------------------------------------------------------------------- 
%    % add digits 1 
%    %---------------------------------------------------------------------- 
%    tempRandom = randperm(size(Image3,2));
%    tempRandom2 = randperm(size(segment,2));
%    for j = 1:20
%         segment(:,tempRandom2(j)) = Image3(:, tempRandom(j));
%    end
%    %---------------------------------------------------------------------- 
   
    segment = segment(:,randperm(size(segment,2))); % randomize the order of digits in the matrix
    
    saveSeg = sprintf('C:\\Users\\User\\Desktop\\digit_segment\\small_matrix\\positive\\segment%d.mat',n);
    save(saveSeg,'segment')
end

%creat negative segments 
for n = 1:1000
    segment = [];
    
    tempRandom = randperm(size(even_Image,2));
    tempImages =[];
    for m = 1:4
        tempImages = [tempImages, even_Image(:, tempRandom(m))];
    end
    segment = [segment,tempImages];
    
    segment = segment(:,randperm(size(segment,2))); % randomize the order of digits in the matrix
    
    saveSeg = sprintf('C:\\Users\\User\\Desktop\\digit_segment\\small_matrix\\negative\\segment%d.mat',n);
    save(saveSeg,'segment')
end




