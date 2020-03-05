%clear all;
%close all;
%clc;

%downsampled: 14*14
%positiveFeaturesDir = 'C:\Users\User\Desktop\IJCNN\digit\Feature\positive\differ_ratio\';
%original:28*28
positiveFeaturesDir = 'C:\Users\User\Desktop\IJCNN\digit\positive\differ_ratio\';
positiveList = dir(fullfile([positiveFeaturesDir '*.mat']));
positiveList(1:length(positiveList)/2) =[];

%downsampled: 14*14
%negativeFeaturesDir = 'C:\Users\User\Desktop\IJCNN\digit\Feature\negative\differ_ratio\';
%original:28*28
negativeFeaturesDir = 'C:\Users\User\Desktop\IJCNN\digit\negative\differ_ratio\';
negtiveList = dir(fullfile([negativeFeaturesDir '*.mat']));
negtiveList(1:length(negtiveList)/2) =[];

%load training data
trainPositiveData = [];
for n =1:5
    temp = [];
    temp = load([positiveFeaturesDir positiveList(n).name]);
    %trainPositiveData = [trainPositiveData, temp.feature];
    trainPositiveData = [trainPositiveData, temp.segment];
end

trainNegativeData = [];
for n =1:40
    temp = [];
    temp = load([negativeFeaturesDir negtiveList(n).name]);
    %trainNegativeData = [trainNegativeData, temp.feature];
    trainNegativeData = [trainNegativeData, temp.segment];
end

%load test data
testPositiveData = [];
for n =6:55
    temp = [];
    temp = load([positiveFeaturesDir positiveList(n).name]);
    %testPositiveData = [testPositiveData, temp.feature];
    testPositiveData = [testPositiveData, temp.segment];
end

testNegativeData = [];
for n =41:90
    temp = [];
    temp = load([negativeFeaturesDir negtiveList(n).name]);
    %testNegativeData = [testNegativeData, temp.feature];
    testNegativeData = [testNegativeData, temp.segment];
end


