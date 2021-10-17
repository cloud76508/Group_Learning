function [trainPositiveData, trainNegativeData, valPositiveData, valNegativeData, testPositiveData, testNegativeData] = loadData_standardSVM(train_pos, train_neg, val_size, test_size)

downsample_factor = 1;

%positiveFeaturesDir = 'D:\yalefaces_positive\';
%positiveList = dir(fullfile([positiveFeaturesDir '*.gif']));

positiveFeaturesDir = 'D:\CroppedYale\yaleB25\';
positiveList = dir(fullfile([positiveFeaturesDir '*.pgm']));

%negativeFeaturesDir = 'D:\yalefaces_negative\';
%negtiveList = dir(fullfile([negativeFeaturesDir '*.gif']));

negativeFeaturesDir = 'D:\CroppedYale\yaleB30\';
negtiveList = dir(fullfile([negativeFeaturesDir '*.pgm']));

%load training data
trainPositiveData = [];
random_positive = randperm(64);
for n =1:train_pos
    temp = [];
    temp = imread([positiveFeaturesDir positiveList(random_positive(n)).name]);
    temp = temp(1:160,1:160);
    temp = im2double(temp);
    %downsampling
    temp = downsample(temp,downsample_factor,0);
    temp = (downsample(temp',downsample_factor,0))';
    
    temp = reshape(temp, [],1);
    trainPositiveData = [trainPositiveData, temp];
end

trainNegativeData = [];
random_negative = randperm(64);
for n =1:train_neg
    temp = [];
    temp = imread([negativeFeaturesDir negtiveList(random_negative(n)).name]);
    temp = temp(1:160,1:160);
    temp = im2double(temp);
    %downsampling
    temp = downsample(temp,downsample_factor,0);
    temp = (downsample(temp',downsample_factor,0))';
    
    temp = reshape(temp, [],1);
    trainNegativeData = [trainNegativeData, temp];
end

%load validation data
valPositiveData = [];
for n =11:10+val_size
    temp = [];
    temp = imread([positiveFeaturesDir positiveList(random_positive(n)).name]);
    temp = temp(1:160,1:160);
    temp = im2double(temp);
    %downsampling
    temp = downsample(temp,downsample_factor,0);
    temp = (downsample(temp',downsample_factor,0))';
    
    temp = reshape(temp, [],1);
    valPositiveData = [valPositiveData, temp];
end

valNegativeData = [];
for n =11:10+val_size
    temp = [];
    %temp = load([negativeFeaturesDir negtiveList(n+200).name]);
    temp = imread([negativeFeaturesDir negtiveList(random_negative(n)).name]);
    temp = temp(1:160,1:160);
    temp = im2double(temp);
    %downsampling
    temp = downsample(temp,downsample_factor,0);
    temp = (downsample(temp',downsample_factor,0))';
    
    temp = reshape(temp, [],1);
    valNegativeData = [valNegativeData, temp];
end

%load test data
testPositiveData = [];
for n =21:64
    temp = [];
    temp = imread([positiveFeaturesDir positiveList(random_positive(n)).name]);
    temp = temp(1:160,1:160);
    temp = im2double(temp);
    %downsampling
    temp = downsample(temp,downsample_factor,0);
    temp = (downsample(temp',downsample_factor,0))';
    
    temp = reshape(temp, [],1);
    testPositiveData = [testPositiveData, temp];
end

testNegativeData = [];
for n =21:64
    temp = [];
    temp = imread([negativeFeaturesDir negtiveList(random_negative(n)).name]);
    temp = temp(1:160,1:160);
    temp = im2double(temp);
    %downsampling
    temp = downsample(temp,downsample_factor,0);
    temp = (downsample(temp',downsample_factor,0))';
    
    temp = reshape(temp, [],1);
    testNegativeData = [testNegativeData, temp];
end

%imshow(reshape(trainNegativeData(:,1),[192,168]))

