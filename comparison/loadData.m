clear all;
close all;
clc;

%positiveFeaturesDir = 'C:\Users\User\Desktop\digit\Feature\positive\';
positiveFeaturesDir = 'C:\Users\User\Desktop\IJCNN\digit\Feature\positive\V1\';
positiveList = dir(fullfile([positiveFeaturesDir '*.mat']));

%negativeFeaturesDir = 'C:\Users\User\Desktop\digit\Feature\negative\';
negativeFeaturesDir = 'C:\Users\User\Desktop\IJCNN\digit\Feature\negative\V1\';
negtiveList = dir(fullfile([negativeFeaturesDir '*.mat']));

%load training data
trainPositiveData = [];
for n =1:5
    temp = [];
    temp = load([positiveFeaturesDir positiveList(n).name]);
    tempSparse = reshape(temp.feature, [],1);
    trainPositiveData = [trainPositiveData,tempSparse];
end

trainNegativeData = [];
for n =1:40
    temp = [];
    temp = load([negativeFeaturesDir negtiveList(n).name]);
    tempSparse = reshape(temp.feature, [],1);
    trainNegativeData = [trainNegativeData, tempSparse];
end

%load test data
testPositiveData = [];
for n =6:55
    temp = [];
    temp = load([positiveFeaturesDir positiveList(n).name]);
    tempSparse = reshape(temp.feature, [],1);
    testPositiveData = [testPositiveData, tempSparse];
end

testNegativeData = [];
for n =41:90
    temp = [];
    temp = load([negativeFeaturesDir negtiveList(n).name]);
    tempSparse = reshape(temp.feature, [],1);
    testNegativeData = [testNegativeData, tempSparse];
end


