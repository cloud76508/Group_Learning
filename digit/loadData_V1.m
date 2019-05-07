%clear all;
%close all;
%clc;

positiveFeaturesDir = 'C:\Users\User\Desktop\IJCNN\digit\Feature\positive\V1\';
positiveList = dir(fullfile([positiveFeaturesDir '*.mat']));

negativeFeaturesDir = 'C:\Users\User\Desktop\IJCNN\digit\Feature\negative\V1\';
negtiveList = dir(fullfile([negativeFeaturesDir '*.mat']));

%load training data
trainPositiveData = [];
for n =1:5
    temp = [];
    temp = load([positiveFeaturesDir positiveList(n).name]);
    trainPositiveData = [trainPositiveData, temp.feature];
end

trainNegativeData = [];
for n =1:40
    temp = [];
    temp = load([negativeFeaturesDir negtiveList(n).name]);
    trainNegativeData = [trainNegativeData, temp.feature];
end

%load test data
testPositiveData = [];
for n =6:55
    temp = [];
    temp = load([positiveFeaturesDir positiveList(n).name]);
    testPositiveData = [testPositiveData, temp.feature];
end

testNegativeData = [];
for n =41:90
    temp = [];
    temp = load([negativeFeaturesDir negtiveList(n).name]);
    testNegativeData = [testNegativeData, temp.feature];
end


