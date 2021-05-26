function [trainPositiveData, trainNegativeData, valPositiveData, valNegativeData,testPositiveList, testNegativeList]  = loadData(train_Pos,train_Neg, val_size, test_size)

%positiveFeaturesDir = 'C:\Users\User\Desktop\digit_segment\small_matrix\positive\';
positiveFeaturesDir = 'C:\Users\ASUS\Desktop\digit\positive\';
positiveList = dir(fullfile([positiveFeaturesDir '*.mat']));

%negativeFeaturesDir = 'C:\Users\User\Desktop\digit_segment\small_matrix\negative\';
negativeFeaturesDir = 'C:\Users\ASUS\Desktop\digit\negative\';
negtiveList = dir(fullfile([negativeFeaturesDir '*.mat']));

%load training data
trainPositiveData = [];
random_positive = randperm(200);
for n =1:train_Pos
    temp = [];
    %temp = load([positiveFeaturesDir positiveList(n).name]);
    temp = load([positiveFeaturesDir positiveList(random_positive(n)).name]);
    trainPositiveData = [trainPositiveData, temp.segment];
end

trainNegativeData = [];
random_negative = randperm(200);
for n =1:train_Neg
    temp = [];
    %temp = load([negativeFeaturesDir negtiveList(n).name]);
    temp = load([negativeFeaturesDir negtiveList(random_negative(n)).name]);
    trainNegativeData = [trainNegativeData, temp.segment];
end

%load validation data
valPositiveData = [];
random_positive_val = randperm(200)+200;
for n =1:val_size
    temp = [];
    %temp = load([positiveFeaturesDir positiveList(n+200).name]);
    temp = load([positiveFeaturesDir positiveList(random_positive_val(n)).name]);
    valPositiveData = [valPositiveData, temp.segment];
end

valNegativeData = [];
random_negative_val = randperm(200)+200;
for n =1:val_size
    temp = [];
    %temp = load([negativeFeaturesDir negtiveList(n+200).name]);
    temp = load([negativeFeaturesDir negtiveList(random_negative_val(n)).name]);
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



