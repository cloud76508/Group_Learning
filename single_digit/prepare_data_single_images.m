clear all
clc

%digits = load('D:\EMNIST\matlab\emnist-digits.mat');
%letters = load('D:\EMNIST\matlab\emnist-letters.mat'); 

digits = loadMNISTImages('emnist-digits-train-images-idx3-ubyte');
digit_labels = loadMNISTLabels('emnist-digits-train-labels-idx1-ubyte');
letters = loadMNISTImages('emnist-letters-train-images-idx3-ubyte');
letters_labels = loadMNISTLabels('emnist-letters-train-labels-idx1-ubyte');

%Image1 = letters(:,letters_labels== 10 | letters_labels==18);
%Image2 = digits(:,digit_labels== 7 | digit_labels==5);

%Image1 = letters(:,letters_labels== 14 | letters_labels==19);
%Image2 = digits(:,digit_labels== 6 | digit_labels==8);

%Image1 = letters(:,letters_labels== 11 | letters_labels==24);
%Image2 = digits(:,digit_labels== 1 | digit_labels==7);

Image1 = digits(:,digit_labels== 3);
Image2 = digits(:,digit_labels== 5);

%Image1 = letters(:,letters_labels== 25);
%Image2 = letters(:,letters_labels== 26);

%Image1 = digits;
%Image2 = letters;

 
%imshow(reshape(dataset.train.images(5,:),28,28))


%creat positive segments (digits)

%creat positive segments (digits)
for n = 1:1000   
    tempRandom = randperm(size(Image1,2));
    tempImages = Image1(:, tempRandom(1));
    segment = tempImages;
    segment = reshape(segment,[28,28]);
    segment = flip(segment);
    segment = imrotate(segment,-90);
    
    %saveSeg = sprintf('C:\\Users\\User\\Desktop\\digit_segment\\small_matrix\\positive\\segment%d.mat',n);
    saveSeg = sprintf('C:\\Users\\ASUS\\Desktop\\digit\\positive\\segment%d.mat',n);
    save(saveSeg,'segment')
end

%creat negative segments 
for n = 1:1000
    tempRandom = randperm(size(Image2,2));
    tempImages = Image2(:, tempRandom(1));
    segment = tempImages;
    segment = reshape(segment,[28,28]);
    segment = flip(segment);
    segment = imrotate(segment,-90);
    
    saveSeg = sprintf('C:\\Users\\ASUS\\Desktop\\digit\\negative\\segment%d.mat',n);
    save(saveSeg,'segment')
end

%display_network(reshape(segment,[],1))


