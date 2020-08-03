function [trainPositiveData, trainNegativeData, valPositiveData, valNegativeData,testPositiveList, testNegativeList]  = loadData(train_size, val_size, test_size)

positiveFeaturesDir = 'C:\Users\User\Desktop\digit_segment\small_matrix\positive\';
positiveList = dir(fullfile([positiveFeaturesDir '*.mat']));

negativeFeaturesDir = 'C:\Users\User\Desktop\digit_segment\small_matrix\negative\';
negtiveList = dir(fullfile([negativeFeaturesDir '*.mat']));


%load training data
trainPositiveData = [];
for n =1:train_size
    temp = [];
    temp = load([positiveFeaturesDir positiveList(n).name]);
    trainPositiveData = [trainPositiveData, temp.segment];
end

trainNegativeData = [];
for n =1:train_size
    temp = [];
    temp = load([negativeFeaturesDir negtiveList(n).name]);
    trainNegativeData = [trainNegativeData, temp.segment];
end

%load validation data
valPositiveData = [];
for n =201:200+val_size
    temp = [];
    temp = load([positiveFeaturesDir positiveList(n).name]);
    valPositiveData = [valPositiveData, temp.segment];
end

valNegativeData = [];
for n =201:200+val_size
    temp = [];
    temp = load([negativeFeaturesDir negtiveList(n).name]);
    valNegativeData = [valNegativeData, temp.segment];
end
 
i = 1;
for n =501:500+test_size
    testPositiveList{i,1} = [positiveFeaturesDir positiveList(n).name];
    i=i+1;
end

i = 1;
for n =501:500+test_size
    testNegativeList{i,1} = [negativeFeaturesDir negtiveList(n).name];
    i=i+1;
end



