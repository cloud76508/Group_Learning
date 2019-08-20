clear all;
close all;
clc;
loadData_one_class

%trn.X = [trainNegativeData';trainPositiveData'];
%trn.y = [-ones(size(trainNegativeData,2),1);ones(size(trainPositiveData,2),1)];

trn.X = [trainNegativeData'];
trn.y = [-ones(size(trainNegativeData,2),1)];

val.X = [valNegativeData'; valPositiveData'];
val.y = [-ones(size(valNegativeData,2),1);ones(size(valPositiveData,2),1)];

% gamma parameter of rbf SVM
%gamma = 10.^(-4:1:4);
gamma = 2.^(-2:1:4);


for idx = 1:size(gamma, 2)
    option_one_class = ['-s 2 -t 2 -n 0.01  -g ', num2str(gamma(idx)), ' -q'];
    mdl = svmtrain(trn.y, sparse(trn.X), option_one_class);
    
    [pred, ~, ~] = svmpredict(val.y, sparse(val.X), mdl);
    crossValAccuracy(idx) = sum(pred == val.y) / length(val.y);  
end
    

%clear learn val;

% -------------------------------------------------------------
% find the optimal C
% -------------------------------------------------------------
[validAcc, opt_C_idx] = max(crossValAccuracy);
opt_C = gamma(opt_C_idx);

% -------------------------------------------------------------
% estimate the model using optiomal C
% -------------------------------------------------------------
% construct the training data

option_one_class = ['-s 2 -t 2 -n 0.01  -g ', num2str(opt_C), ' -q'];
model = svmtrain(trn.y, sparse(trn.X), option_one_class);

[~, ~, decPos] = svmpredict(ones(size(trainPositiveData,2),1), sparse(trainPositiveData'), model);
[~, ~, decNeg] = svmpredict(-ones(size(trainNegativeData,2),1), sparse(trainNegativeData'), model);

[~, ~, decValPos] = svmpredict(ones(size(valPositiveData,2),1), sparse(valPositiveData'), model);
[~, ~, decValNeg] = svmpredict(-ones(size(valNegativeData,2),1), sparse(valNegativeData'), model);

%--------------------------------------------------------------
% apply model to the test data
%--------------------------------------------------------------
decValuesPosiTest = [];
decValuesNegaTest = [];
tempPosiTest =[];
tempNageTest = [];
for n =1:size(testPositiveList,1)
    testPositiveData = load(testPositiveList{n}');
    [~, ~, tempPosiTest] = svmpredict(ones(size(testPositiveData.feature,2), 1), sparse(testPositiveData.feature'), model);
    decValuesPosiTest = [decValuesPosiTest; tempPosiTest'];
end

for n =1:size(testNegativeList,1)
    testNegativeData = load(testNegativeList{n}');
    [~, ~, tempNegaTest] = svmpredict(-ones(size(testNegativeData.feature,2), 1), sparse(testNegativeData.feature'), model);
    decValuesNegaTest = [decValuesNegaTest; tempNegaTest'];
end




