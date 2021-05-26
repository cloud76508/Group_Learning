clear all
clc

AA = imread('D:\Real_and_Fake_Face_Detection\archive\real_and_fake_face\training_fake\easy_1_1110.jpg');
BB = rgb2gray(AA);

positiveFeaturesDir = 'D:\Real_and_Fake_Face_Detection\archive\real_and_fake_face\training_real\';
positiveList = dir(fullfile([positiveFeaturesDir '*.jpg']));

negativeFeaturesDir = 'D:\Real_and_Fake_Face_Detection\archive\real_and_fake_face\training_fake\';
negtiveList = dir(fullfile([negativeFeaturesDir '*.jpg']));

%creat positive segments (digits)
for n = 1:900   
    tempRandom = randperm(size(positiveList,1));
    tempImages = Image1(:, tempRandom(1));
    segment = tempImages;
    segment = reshape(segment,[28,28]);
    segment = flip(segment);
    segment = imrotate(segment,-90);
    
    %saveSeg = sprintf('C:\\Users\\User\\Desktop\\digit_segment\\small_matrix\\positive\\segment%d.mat',n);
    saveSeg = sprintf('C:\\Users\\ASUS\\Desktop\\images\\positive\\segment%d.mat',n);
    save(saveSeg,'segment')
end

%creat negative segments 
for n = 1:900
    tempRandom = randperm(size(Image2,2));
    tempImages = Image2(:, tempRandom(1));
    segment = tempImages;
    segment = reshape(segment,[28,28]);
    segment = flip(segment);
    segment = imrotate(segment,-90);
    
    saveSeg = sprintf('C:\\Users\\ASUS\\Desktop\\images\\negative\\segment%d.mat',n);
    save(saveSeg,'segment')
end

%display_network(reshape(segment,[],1))


