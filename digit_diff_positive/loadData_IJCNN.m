%clear all;
%close all;
%clc;

neg_feature_path = 'C:\Users\User\Desktop\digit_segment\feature\negative\';
pos_feature_path = 'C:\Users\User\Desktop\digit_segment\feature\positive\';
pos_diff_feature_path = 'C:\Users\User\Desktop\digit_segment\feature\positive_diff\';

negtiveList = dir(fullfile([neg_feature_path '*.mat']));
positiveList = dir(fullfile([pos_feature_path '*.mat']));
positiveDiffList = dir(fullfile([pos_diff_feature_path '*.mat']));

%load training data
trainPositiveData = [];
for n =1:5
    temp = [];
    temp = load([pos_feature_path positiveList(n).name]);
    %trainPositiveData = [trainPositiveData, temp.segment];
    trainPositiveData = [trainPositiveData, temp.feature];
end

trainNegativeData = [];
for n =1:40
    temp = [];
    temp = load([neg_feature_path negtiveList(n).name]);
    %trainNegativeData = [trainNegativeData, temp.segment];
    trainNegativeData = [trainNegativeData, temp.feature];
end

%load validation data
valPositiveData = [];
for n =41:80
    temp = [];
    temp = load([pos_feature_path positiveList(n).name]);
    %valPositiveData = [valPositiveData, temp.segment];
    valPositiveData = [valPositiveData, temp.feature];
end

valNegativeData = [];
for n =41:80
    temp = [];
    temp = load([neg_feature_path negtiveList(n).name]);
    %valNegativeData = [valNegativeData, temp.segment];
    valNegativeData = [valNegativeData, temp.feature];
end

i = 1;
for n =1:500
    testPositiveList{i,1} = [pos_diff_feature_path positiveDiffList(n).name];
    i=i+1;
end

i = 1;
for n =81:580
    testNegativeList{i,1} = [neg_feature_path negtiveList(n).name];
    i=i+1;
end


