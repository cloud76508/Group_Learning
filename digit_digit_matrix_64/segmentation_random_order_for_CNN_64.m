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


%creat positive segments [7,2,8,6;7,2,8,6;7,2,8,6;7,2,8,6]
for n = 1:1000
    segment = [];
    
%     tempRandom = randperm(size(Image1,2));
%     tempImages = [Image1(:, tempRandom(1)), ...
%         Image1(:, tempRandom(2)),Image1(:, tempRandom(3)),...
%         Image1(:, tempRandom(4)),Image1(:, tempRandom(5)),... 
%         Image1(:, tempRandom(6)),Image1(:, tempRandom(7)),... 
%         Image1(:, tempRandom(8)),Image1(:, tempRandom(9)),... 
%         Image1(:, tempRandom(10)),Image1(:, tempRandom(11)),...
%         Image1(:, tempRandom(12)),Image1(:, tempRandom(13)),...
%         Image1(:, tempRandom(14)),Image1(:, tempRandom(15)),...
%         Image1(:, tempRandom(16))];
%     segment = [segment,tempImages];
    
    
    tempRandom = randperm(size(Image7,2));
    tempImages = [Image7(:, tempRandom(1)), ...
        Image7(:, tempRandom(2)),Image7(:, tempRandom(3)),...
        Image7(:, tempRandom(4)),Image7(:, tempRandom(5)),...
        Image7(:, tempRandom(6)),Image7(:, tempRandom(7)),...
        Image7(:, tempRandom(8)),Image1(:, tempRandom(9)),...
        Image1(:, tempRandom(10)),Image1(:, tempRandom(11)),...
        Image1(:, tempRandom(12)),Image1(:, tempRandom(13)),...
        Image1(:, tempRandom(14)),Image1(:, tempRandom(15)),...
        Image1(:, tempRandom(16))];
    segment = [segment,tempImages];
       
    tempRandom = randperm(size(Image2,2));
    tempImages = [Image2(:, tempRandom(1)), ...
        Image2(:, tempRandom(2)),Image2(:, tempRandom(3)),...
        Image2(:, tempRandom(4)),Image2(:, tempRandom(5)),...
        Image2(:, tempRandom(6)),Image2(:, tempRandom(7)),...
        Image2(:, tempRandom(8)),Image2(:, tempRandom(9)),...
        Image2(:, tempRandom(10)),Image2(:, tempRandom(11)),...
        Image2(:, tempRandom(12)),Image2(:, tempRandom(13)),...
        Image2(:, tempRandom(14)),Image2(:, tempRandom(15)),...
        Image2(:, tempRandom(16))];
    segment = [segment,tempImages];
    
    tempRandom = randperm(size(Image3,2));
    tempImages = [Image3(:, tempRandom(1)), ...
        Image3(:, tempRandom(2)),Image3(:, tempRandom(3)),... 
        Image3(:, tempRandom(4)),Image3(:, tempRandom(5)),... 
        Image3(:, tempRandom(6)),Image3(:, tempRandom(7)),... 
        Image3(:, tempRandom(8)),Image3(:, tempRandom(9)),... 
        Image3(:, tempRandom(10)),Image3(:, tempRandom(11)),...
        Image3(:, tempRandom(12)),Image3(:, tempRandom(13)),...
        Image3(:, tempRandom(14)),Image3(:, tempRandom(15)),...
        Image3(:, tempRandom(16))];
    segment = [segment,tempImages];
    
    tempRandom = randperm(size(Image4,2));
    tempImages = [Image4(:, tempRandom(1)), ...
        Image4(:, tempRandom(2)),Image4(:, tempRandom(3)),... 
        Image4(:, tempRandom(4)),Image4(:, tempRandom(5)),... 
        Image4(:, tempRandom(6)),Image4(:, tempRandom(7)),... 
        Image4(:, tempRandom(8)),Image4(:, tempRandom(9)),... 
        Image4(:, tempRandom(10)),Image4(:, tempRandom(11)),...
        Image4(:, tempRandom(12)),Image4(:, tempRandom(13)),...
        Image4(:, tempRandom(14)),Image4(:, tempRandom(15)),...
        Image4(:, tempRandom(16))];
    segment = [segment,tempImages];
    
    segment = segment(:,randperm(size(segment,2))); % randomize the order of digits in the matrix
    
    % reshape segment to 28*4x28*4
    segment_raw = zeros(28*8,28*8);
    i = 0;
    j = 0;
    for m = 1:size(segment,2)
        temp = segment(:,m);
        temp = reshape(temp,[28,28]);
        if j == 8 && i<8
           i = i+1;
           j = 0;
        end
        segment_raw(i*28+1:(i+1)*28,j*28+1:(j+1)*28) = temp;
        j = j+1;
    end
    segment = segment_raw;
    
    %saveSeg = sprintf('C:\\Users\\User\\Desktop\\digit_segment\\small_matrix\\positive\\segment%d.mat',n);
    saveSeg = sprintf('C:\\Users\\ASUS\\Desktop\\digit\\positive\\segment%d.mat',n);
    save(saveSeg,'segment')
end

%creat negative segments [1,2,3,4;1,2,3,4;1,2,3,4;1,2,3,4]
for n = 1:1000
    segment = [];
    
%     tempRandom = randperm(size(Image7,2));
%     tempImages = [Image7(:, tempRandom(1)), ...
%         Image7(:, tempRandom(2)),Image7(:, tempRandom(3)),...
%         Image7(:, tempRandom(4)),Image7(:, tempRandom(5)),...
%         Image7(:, tempRandom(6)),Image7(:, tempRandom(7)),...
%         Image7(:, tempRandom(8)),Image1(:, tempRandom(9)),...
%         Image1(:, tempRandom(10)),Image1(:, tempRandom(11)),...
%         Image1(:, tempRandom(12)),Image1(:, tempRandom(13)),...
%         Image1(:, tempRandom(14)),Image1(:, tempRandom(15)),...
%         Image1(:, tempRandom(16))];
%     segment = [segment,tempImages];
    
    
    tempRandom = randperm(size(Image1,2));
    tempImages = [Image1(:, tempRandom(1)), ...
        Image1(:, tempRandom(2)),Image1(:, tempRandom(3)),...
        Image1(:, tempRandom(4)),Image1(:, tempRandom(5)),... 
        Image1(:, tempRandom(6)),Image1(:, tempRandom(7)),... 
        Image1(:, tempRandom(8)),Image1(:, tempRandom(9)),... 
        Image1(:, tempRandom(10)),Image1(:, tempRandom(11)),...
        Image1(:, tempRandom(12)),Image1(:, tempRandom(13)),...
        Image1(:, tempRandom(14)),Image1(:, tempRandom(15)),...
        Image1(:, tempRandom(16))];
    segment = [segment,tempImages];
    
    tempRandom = randperm(size(Image2,2));
    tempImages = [Image2(:, tempRandom(1)), ...
        Image2(:, tempRandom(2)),Image2(:, tempRandom(3)),... 
        Image2(:, tempRandom(4)),Image2(:, tempRandom(5)),...
        Image2(:, tempRandom(6)),Image2(:, tempRandom(7)),...
        Image2(:, tempRandom(8)),Image2(:, tempRandom(9)),...
        Image2(:, tempRandom(10)),Image2(:, tempRandom(11)),...
        Image2(:, tempRandom(12)),Image2(:, tempRandom(13)),...
        Image2(:, tempRandom(14)),Image2(:, tempRandom(15)),...
        Image2(:, tempRandom(16))];
    segment = [segment,tempImages];
    
    tempRandom = randperm(size(Image3,2));
    tempImages = [Image3(:, tempRandom(1)), ...
        Image3(:, tempRandom(2)),Image3(:, tempRandom(3)),... 
        Image3(:, tempRandom(4)),Image3(:, tempRandom(5)),... 
        Image3(:, tempRandom(6)),Image3(:, tempRandom(7)),... 
        Image3(:, tempRandom(8)),Image3(:, tempRandom(9)),... 
        Image3(:, tempRandom(10)),Image3(:, tempRandom(11)),...
        Image3(:, tempRandom(12)),Image3(:, tempRandom(13)),...
        Image3(:, tempRandom(14)),Image3(:, tempRandom(15)),...
        Image3(:, tempRandom(16))];
    segment = [segment,tempImages];
    
    tempRandom = randperm(size(Image4,2));
    tempImages = [Image4(:, tempRandom(1)), ...
        Image4(:, tempRandom(2)),Image4(:, tempRandom(3)),... 
        Image4(:, tempRandom(4)),Image4(:, tempRandom(5)),...
        Image4(:, tempRandom(6)),Image4(:, tempRandom(7)),...
        Image4(:, tempRandom(8)),Image4(:, tempRandom(9)),...
        Image4(:, tempRandom(10)),Image4(:, tempRandom(11)),...
        Image4(:, tempRandom(12)),Image4(:, tempRandom(13)),...
        Image4(:, tempRandom(14)),Image4(:, tempRandom(15)),...
        Image4(:, tempRandom(16))];
    segment = [segment,tempImages];
    
    segment = segment(:,randperm(size(segment,2))); % randomize the order of digits in the matrix
    
    % reshape segment to 28*4x28*4
    segment_raw = zeros(28*8,28*8);
    i = 0;
    j = 0;
    for m = 1:size(segment,2)
        temp = segment(:,m);
        temp = reshape(temp,[28,28]);
        if j == 8 && i<8
           i = i+1;
           j = 0;
        end
        segment_raw(i*28+1:(i+1)*28,j*28+1:(j+1)*28) = temp;
        j = j+1;
    end
    segment = segment_raw;
    
    %saveSeg = sprintf('C:\\Users\\User\\Desktop\\digit_segment\\small_matrix\\negative\\segment%d.mat',n);
    saveSeg = sprintf('C:\\Users\\ASUS\\Desktop\\digit\\negative\\segment%d.mat',n);
    save(saveSeg,'segment')
end

%display_network(reshape(segment,[],1))

