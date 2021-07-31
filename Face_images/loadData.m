function [trainPositiveData, trainNegativeData, valPositiveData, valNegativeData,testPositiveList, testNegativeList]  = loadData(train_Pos,train_Neg, val_size, test_size)

positiveFeaturesDir = 'D:\CroppedYale\yaleB33\';
positiveList = dir(fullfile([positiveFeaturesDir '*.pgm']));

negativeFeaturesDir = 'D:\CroppedYale\yaleB27\';
negtiveList = dir(fullfile([negativeFeaturesDir '*.pgm']));

%load training data
trainPositiveData = [];
random_positive = randperm(64);
for n =1:train_Pos
    temp = [];
    temp = imread([positiveFeaturesDir positiveList(random_positive(n)).name]);
    temp = temp(1:160,1:160);
    %temp = rgb2gray(temp);
    temp = im2double(temp);
    %temp = reshape(temp, [600*600,1]);
    trainPositiveData = [trainPositiveData, temp];
end

trainNegativeData = [];
random_negative = randperm(64);
for n =1:train_Neg
    temp = [];
    temp = imread([negativeFeaturesDir negtiveList(random_negative(n)).name]);
    temp = temp(1:160,1:160);
    %temp = rgb2gray(temp);
    temp = im2double(temp);
    %temp = reshape(temp, [600*600,1]);
    trainNegativeData = [trainNegativeData, temp];
end

%load validation data
valPositiveData = [];
for n =11:10+val_size
    temp = [];
    temp = imread([positiveFeaturesDir positiveList(random_positive(n)).name]);
    temp = temp(1:160,1:160);
    %temp = rgb2gray(temp);
    temp = im2double(temp);
    %temp = reshape(temp, [600*600,1]);
    valPositiveData = [valPositiveData, temp];
end

valNegativeData = [];
random_negative_val = randperm(200)+200;
for n =11:10+val_size
    temp = [];
    %temp = load([negativeFeaturesDir negtiveList(n+200).name]);
    temp = imread([negativeFeaturesDir negtiveList(random_negative(n)).name]);
    temp = temp(1:160,1:160);
    %temp = rgb2gray(temp);
    temp = im2double(temp);
    %temp = reshape(temp, [600*600,1]);
    valNegativeData = [valNegativeData, temp];
end
 
i = 1;
for n =21:64
    testPositiveList{i,1} = [positiveFeaturesDir positiveList(random_positive(n)).name];
    i=i+1;
end

i = 1;
for n =21:64
    testNegativeList{i,1} = [negativeFeaturesDir negtiveList(random_negative(n)).name];
    i=i+1;
end






