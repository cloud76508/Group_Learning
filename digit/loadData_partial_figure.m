%clear all;
%close all;
%clc;

%partial
positiveFeaturesDir = 'C:\Users\User\Desktop\IJCNN\digit\Feature\positive\partial\';
positiveList = dir(fullfile([positiveFeaturesDir '*.mat']));

%partial
negativeFeaturesDir = 'C:\Users\User\Desktop\IJCNN\digit\Feature\negative\partial\';
negtiveList = dir(fullfile([negativeFeaturesDir '*.mat']));


%load training data
trainPositiveData = [];
for n =1:5
    temp = [];
    temp = load([positiveFeaturesDir positiveList(n).name]);
    %trainPositiveData = [trainPositiveData, temp.segment];
    trainPositiveData = [trainPositiveData, temp.feature];
end

trainNegativeData = [];
for n =1:40
    temp = [];
    temp = load([negativeFeaturesDir negtiveList(n).name]);
    %trainNegativeData = [trainNegativeData, temp.segment];
    trainNegativeData = [trainNegativeData, temp.feature];
end

%load validation data
valPositiveData = [];
for n =41:80
    temp = [];
    temp = load([positiveFeaturesDir positiveList(n).name]);
    %valPositiveData = [valPositiveData, temp.segment];
    valPositiveData = [valPositiveData, temp.feature];
end

valNegativeData = [];
for n =41:80
    temp = [];
    temp = load([negativeFeaturesDir negtiveList(n).name]);
    %valNegativeData = [valNegativeData, temp.segment];
    valNegativeData = [valNegativeData, temp.feature];
end

i = 1;
for n =101:600
    testPositiveList{i,1} = [positiveFeaturesDir positiveList(n).name];
    i=i+1;
end

i = 1;
for n =101:600
    testNegativeList{i,1} = [negativeFeaturesDir negtiveList(n).name];
    i=i+1;
end

% %load test data
% testPositiveData = [];
% for n =101:600
%     temp = [];
%     temp = load([positiveFeaturesDir positiveList(n).name]);
%     testPositiveData = [testPositiveData, temp.segment];
% end
% 
% testNegativeData = [];
% for n =101:600
%     temp = [];
%     temp = load([negativeFeaturesDir negtiveList(n).name]);
%     testNegativeData = [testNegativeData, temp.segment];
% end


