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
    temp.segment = reshape(temp.segment, [],1); % for standard SVM
    trainPositiveData = [trainPositiveData, temp.segment];
end

trainNegativeData = [];
for n =1:100
    temp = [];
    temp = load([negativeFeaturesDir negtiveList(n).name]);
    temp.segment = reshape(temp.segment, [],1); % for standard SVM
    trainNegativeData = [trainNegativeData, temp.segment];
end

%load validation data
valPositiveData = [];
for n =101:200
    temp = [];
    temp = load([positiveFeaturesDir positiveList(n).name]);
    temp.segment = reshape(temp.segment, [],1); % for standard SVM
    valPositiveData = [valPositiveData, temp.segment];
end

valNegativeData = [];
for n =101:200
    temp = [];
    temp = load([negativeFeaturesDir negtiveList(n).name]);
    temp.segment = reshape(temp.segment, [],1); % for standard SVM
    valNegativeData = [valNegativeData, temp.segment];
end
 
% i = 1;
% for n =201:700
%     testPositiveList{i,1} = [positiveFeaturesDir positiveList(n).name];
%     i=i+1;
% end
% 
% i = 1;
% for n =201:700
%     testNegativeList{i,1} = [negativeFeaturesDir negtiveList(n).name];
%     i=i+1;
% end

%load test data
testPositiveData = [];
for n =201:700
    temp = [];
    temp = load([positiveFeaturesDir positiveList(n).name]);
    temp.segment = reshape(temp.segment, [],1); % for standard SVM
    testPositiveData = [testPositiveData, temp.segment];
end

testNegativeData = [];
for n =201:700
    temp = [];
    temp = load([negativeFeaturesDir negtiveList(n).name]);
    temp.segment = reshape(temp.segment, [],1); % for standard SVM
    testNegativeData = [testNegativeData, temp.segment];
end


