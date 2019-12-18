clear all;
close all;
clc;

loadData

[rawData,maxV,minV] = normalization(rawData);

for n =1:length(label)
   if label(n) ==0
       label(n) = -1;
   end
end

originLabel = label;

%cut some features for performing group learning
rawData(:,9801:end) = [];

groupSize = 25; 

groupData = [];
for n =1:size(rawData,1)
    groupData = [groupData; reshape(rawData(n,:), [],groupSize)'];
end

groupLabel = [ones(sum(label == 1)*groupSize,1);-ones(sum(label == -1)*groupSize,1)];

rawData = groupData;
label = groupLabel;

crossValAccuracy = [];

tstResults = [];
weight = 1;
%weight = 0.1875;


for n = 1:size(rawData,1)/groupSize
    trainSet.X = rawData;
    trainSet.y = label;
    test.X = rawData((n-1)*groupSize+1:n*groupSize,:);
    test.y = label((n-1)*groupSize+1:n*groupSize);
    trainSet.X((n-1)*groupSize+1:n*groupSize,:) = [];
    trainSet.y((n-1)*groupSize+1:n*groupSize) = [];
   
%     randOrder = randperm(size(trainNegativeData,1));
%     trainNegativeData = trainNegativeData(randOrder,:);
    
    trainPositiveData = trainSet.X(trainSet.y==1,:);
    trainNegativeData = trainSet.X(trainSet.y==-1,:);

    setFold = sum(trainSet.y == 1)/groupSize;
    
    for fold = 1:setFold       
        learnNeg = trainNegativeData;
        learnNeg((fold-1)*groupSize+1:fold*groupSize,:) = [];
        learnPos = trainPositiveData;
        learnPos((fold-1)*groupSize+1:fold*groupSize,:) = [];
        learn.X = [learnPos;learnNeg];
        learn.y = [ones(size(learnPos,1),1);-ones(size(learnNeg,1),1)];
        
        valNeg = trainNegativeData((fold-1)*groupSize+1:fold*groupSize,:);
        valPos = trainPositiveData((fold-1)*groupSize+1:fold*groupSize,:);
        val.X = [valPos; valNeg];
        val.y = [ones(size(valPos,1),1);-ones(size(valNeg,1),1)];
        
        % C parameter of SVM
        C = 10.^(-4:1:4);
        
        for idx = 1:size(C, 2)
            option_liblinear = ['-w+1 ', num2str(weight), ' -w-1 1 -c ', num2str(C(idx)), ' -s 1 -q'];
            mdl = train(learn.y, sparse(learn.X), option_liblinear);
            
            [pred, ~, ~] = predict(val.y, sparse(val.X), mdl);
            crossValAccuracy(idx, fold) = sum(pred == val.y) / length(val.y);
            
            %%% ----- or specify a 'validation function' in do_binary_predict()
             %[pred, crossValAccuracy(idx,fold), dec] = do_binary_predict(val.y, sparse(val.X), mdl);
        end
    end
    
    % -------------------------------------------------------------
    % find the optimal C
    % -------------------------------------------------------------
    [validAcc, opt_C_idx] = max(mean(crossValAccuracy, 2));
    opt_C = C(opt_C_idx);
    
    % -------------------------------------------------------------
    % estimate the model using optiomal C
    % -------------------------------------------------------------
    option_liblinear = ['-w+1 ', num2str(weight), ' -w-1 1 -c ', num2str(opt_C), ' -s 1 -q'];
    model = train(trainSet.y, sparse(trainSet.X), option_liblinear);
    
    % outputs for training data
    decPos = [];
    decNeg = [];
    [~, ~, decPos] = predict(ones(size(trainPositiveData,1),1), sparse(trainPositiveData), model);
    [~, ~, decNeg] = predict(-ones(size(trainNegativeData,1),1), sparse(trainNegativeData), model);
    
    decNeg = reshape(decNeg,groupSize,[])';
    decPos = reshape(decPos,groupSize,[])';
    meanNeg = mean(decNeg');
    meanPos = mean(decPos');
    
    [~, ~, decTest] = predict(test.y, sparse(test.X), model);
    
    if min(meanPos)> max(meanNeg)
        if mean(decTest) > max(meanNeg)
            tstResults = [tstResults;1]
        else
            tstResults = [tstResults; -1]
        end
    else
        if mean(decTest) > min(meanPos)
            tstResults = [tstResults;1]
        else
            tstResults = [tstResults; -1]
        end
    end
        
end


