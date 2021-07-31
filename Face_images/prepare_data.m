clear all
clc

%AA = imread('D:\Real_and_Fake_Face_Detection\archive\real_and_fake_face\training_fake\easy_1_1110.jpg');
%BB = rgb2gray(AA);

train_Pos = 20;
train_Neg = 20;
val_size = 20;
test_size = 300;

positiveFeaturesDir = 'D:\Real_and_Fake_Face_Detection\archive\real_and_fake_face\training_real\';
positiveList = dir(fullfile([positiveFeaturesDir '*.jpg']));

%negativeFeaturesDir = 'C:\Users\User\Desktop\digit_segment\small_matrix\negative\';
negativeFeaturesDir = 'D:\Real_and_Fake_Face_Detection\archive\real_and_fake_face\training_fake\';
negtiveList = dir(fullfile([negativeFeaturesDir '*.jpg']));

%load training data
trainPositiveData = [];
random_positive = randperm(200);
for n =1:train_Pos
    temp = [];
    temp = imread([positiveFeaturesDir positiveList(random_positive(n)).name]);
    temp = rgb2gray(temp);
    temp = im2double(temp);
    temp = reshape(temp, [600*600,1]);
    trainPositiveData = [trainPositiveData, temp];
end

trainNegativeData = [];
random_negative = randperm(200);
for n =1:train_Neg
    temp = [];
    temp = imread([negativeFeaturesDir negtiveList(random_negative(n)).name]);
    temp = rgb2gray(temp);
    temp = im2double(temp);
    temp = reshape(temp, [600*600,1]);
    trainNegativeData = [trainNegativeData, temp];
end

%load validation data
valPositiveData = [];
random_positive_val = randperm(200)+200;
for n =1:val_size
    temp = [];
    temp = imread([positiveFeaturesDir positiveList(random_positive_val(n)).name]);
    temp = rgb2gray(temp);
    temp = im2double(temp);
    temp = reshape(temp, [600*600,1]);
    valPositiveData = [valPositiveData, temp];
end

valNegativeData = [];
random_negative_val = randperm(200)+200;
for n =1:val_size
    temp = [];
    %temp = load([negativeFeaturesDir negtiveList(n+200).name]);
    temp = imread([negativeFeaturesDir negtiveList(random_negative_val(n)).name]);
    temp = rgb2gray(temp);
    temp = im2double(temp);
    temp = reshape(temp, [600*600,1]);
    valNegativeData = [valNegativeData, temp];
end
 
i = 1;
for n =401:400+test_size
    testPositiveList{i,1} = [positiveFeaturesDir positiveList(n).name];
    i=i+1;
end

i = 1;
for n =401:400+test_size
    testNegativeList{i,1} = [negativeFeaturesDir negtiveList(n).name];
    i=i+1;
end


