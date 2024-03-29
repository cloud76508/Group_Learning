clear all;
close all;
clc;

loadData

[rawData,maxV,minV] = normalization(rawData);

% data.X = rawData;
% data.y = label;

% randOrder = randperm(length(label));0
% data.X = rawData(randOrder,:);
% data.y = label(randOrder,1);

for n =1:length(label)
   if label(n) ==0
       label(n) = -1;
   end
end

% Just for simple test
% mdl = svmtrain(data.y, data.X,'-w-0.00001 1 -w+1 1 -c 100000 -t 1 ');
% [pred, ~, ~] = svmpredict(data.y, sparse(data.X), mdl);
% pred

trainPositiveData = rawData(label==1,:);
trainNegativeData = rawData(label==-1,:);
crossValAccuracy = [];

tstResults = [];
weight = 1;
%weight = 0.1875;


for n = 1:size(rawData,1)
    trainSet.X = rawData;
    trainSet.y = label;
    test.X = rawData(n,:);
    test.y = label(n);
    trainSet.X(n,:) = [];
    trainSet.y(n) = [];
    
    trainPositiveData = trainSet.X(trainSet.y==1,:);
    trainNegativeData = trainSet.X(trainSet.y==-1,:);
    
%     randOrder = randperm(size(trainNegativeData,1));
%     trainNegativeData = trainNegativeData(randOrder,:);
      
    setFold = sum(trainSet.y == 1);
    
    for fold = 1:setFold       
        learnNeg = trainNegativeData;
        learnNeg(fold,:) = [];
        learnPos = trainPositiveData;
        learnPos(fold,:) = [];
        learn.X = [learnNeg; learnPos];
        learn.y = [-ones(size(learnNeg,1),1);ones(size(learnPos,1),1)];
        
        valNeg = trainNegativeData(fold,:);
        valPos = trainPositiveData(fold,:);
        val.X = [valNeg; valPos];
        val.y = [-ones(size(valNeg,1),1);ones(size(valPos,1),1)];
        
        % C parameter of SVM
        C = 10.^(-4:1:4);
        
        for idx = 1:size(C, 2)
            option_liblinear = ['-w+1 ', num2str(weight), ' -w-1 1 -c ', num2str(C(idx)), ' -s 1 -q'];
            mdl = train(learn.y, sparse(learn.X), option_liblinear);
            
            [pred, ~, ~] = predict(val.y, sparse(val.X), mdl);
            crossValAccuracy(idx, fold) = sum(pred == val.y) / length(val.y);
            
            %%% ----- or specify a 'validation function' in do_binary_predict()
            % [pred, crossValAccuracy(idx,fold), dec] = do_binary_predict(val.y, sparse(val.X), mdl);
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
   
    [~, ~, decTest] = predict(test.y, sparse(test.X), model);
    tstResults = [tstResults;decTest]
    
end

SS = sum(tstResults(1:12)> 0)/12
SP = sum(tstResults(13:end)< 0)/64

