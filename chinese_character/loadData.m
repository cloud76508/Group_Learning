function [trainPositiveData, trainNegativeData, valPositiveData, valNegativeData,testPositiveList, testNegativeList]  = loadData(train_pos,train_neg, val_size, test_size)

%positiveFeaturesDir = 'C:\Users\User\Desktop\digit_segment\small_matrix\positive\';
positiveFeaturesDir = 'D:\Handwritten_chinese\ETL\single_characters\cn\';
positiveList = dir(fullfile([positiveFeaturesDir '*.mat']));
positiveList = positiveList(randperm(size(positiveList,1)),:);

%negativeFeaturesDir = 'C:\Users\User\Desktop\digit_segment\small_matrix\negative\';.
negativeFeaturesDir = 'D:\Handwritten_chinese\ETL\single_characters\jp\';
negtiveList = dir(fullfile([negativeFeaturesDir '*.mat']));
negtiveList = negtiveList(randperm(size(negtiveList,1)),:);

%load training data
trainPositiveData = [];
random_positive = randperm(2000);
for n =1:train_pos
    temp = [];
    %temp = load([positiveFeaturesDir positiveList(n).name]);
    temp = load([positiveFeaturesDir positiveList(random_positive(n)).name]);
    trainPositiveData = [trainPositiveData, temp.character];
end

trainNegativeData = [];
random_negative = randperm(2000);
for n =1:train_neg
    temp = [];
    %temp = load([negativeFeaturesDir negtiveList(n).name]);
    temp = load([negativeFeaturesDir negtiveList(random_negative(n)).name]);
    trainNegativeData = [trainNegativeData, temp.character];
end

%load validation data
valPositiveData = [];
random_positive_val = randperm(2000)+2000;
for n =1:val_size
    temp = [];
    %temp = load([positiveFeaturesDir positiveList(n+200).name]);
    temp = load([positiveFeaturesDir positiveList(random_positive_val(n)).name]);
    valPositiveData = [valPositiveData, temp.character];
end

valNegativeData = [];
random_negative_val = randperm(2000)+2000;
for n =1:val_size
    temp = [];
    %temp = load([negativeFeaturesDir negtiveList(n+200).name]);
    temp = load([negativeFeaturesDir negtiveList(random_negative_val(n)).name]);
    valNegativeData = [valNegativeData, temp.character];
end

 
i = 1;
for n =5001:5000+test_size
    testPositiveList{i,1} = [positiveFeaturesDir positiveList(n).name];
    i=i+1;
end

i = 1;
for n =5001:5000+test_size
    testNegativeList{i,1} = [negativeFeaturesDir negtiveList(n).name];
    i=i+1;
end




