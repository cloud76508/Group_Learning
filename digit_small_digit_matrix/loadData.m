clear all;
close all;
clc;

positiveFeaturesDir = 'C:\Users\User\Desktop\digit_segment\small_matrix\positive\';
positiveList = dir(fullfile([positiveFeaturesDir '*.mat']));

negativeFeaturesDir = 'C:\Users\User\Desktop\digit_segment\small_matrix\negative\';
negtiveList = dir(fullfile([negativeFeaturesDir '*.mat']));


%load training data
trainPositiveData = [];
for n =1:10
    temp = [];
    temp = load([positiveFeaturesDir positiveList(n).name]);
    trainPositiveData = [trainPositiveData, temp.segment];
end

trainNegativeData = [];
for n =1:10
    temp = [];
    temp = load([negativeFeaturesDir negtiveList(n).name]);
    trainNegativeData = [trainNegativeData, temp.segment];
end

%load validation data
valPositiveData = [];
for n =101:110
    temp = [];
    temp = load([positiveFeaturesDir positiveList(n).name]);
    valPositiveData = [valPositiveData, temp.segment];
end

valNegativeData = [];
for n =101:110
    temp = [];
    temp = load([negativeFeaturesDir negtiveList(n).name]);
    valNegativeData = [valNegativeData, temp.segment];
end
 
i = 1;
for n =201:700
    testPositiveList{i,1} = [positiveFeaturesDir positiveList(n).name];
    i=i+1;
end

i = 1;
for n =201:700
    testNegativeList{i,1} = [negativeFeaturesDir negtiveList(n).name];
    i=i+1;
end



