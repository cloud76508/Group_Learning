clear all;
close all;
clc;
sample_size = 10;
[trainPositiveData, trainNegativeData, valPositiveData,...
    valNegativeData,testPositiveList, testNegativeList]  = loadData(sample_size, sample_size, 500);


trn.X = [trainNegativeData';trainPositiveData'];
trn.y = [-ones(size(trainNegativeData,2),1);ones(size(trainPositiveData,2),1)];

val.X = [valNegativeData'; valPositiveData'];
val.y = [-ones(size(valNegativeData,2),1);ones(size(valPositiveData,2),1)];

% C parameter of SVM
C = 10.^(-4:1:4);
%C = 10.^(-1:1:1);

% weight parameter of SVM
weight = 1;

for idx = 1:size(C, 2)
    option_liblinear = ['-w+1 ', num2str(weight), ' -w-1 1 -c ', num2str(C(idx)), ' -s 1 -q'];
    mdl = train(trn.y, sparse(trn.X), option_liblinear);
    
    %%% ----- do this -----
    [pred, ~, ~] = predict(val.y, sparse(val.X), mdl);
    crossValAccuracy(idx) = sum(pred == val.y) / length(val.y);
    
    %%% ----- or specify a 'validation function' in do_binary_predict()
    %[pred, crossValAccuracy(idx), dec] = do_binary_predict(val.y, sparse(val.X), mdl);
end
    

%clear learn val;

% -------------------------------------------------------------
% find the optimal C
% -------------------------------------------------------------
[validAcc, opt_C_idx] = max(crossValAccuracy);
opt_C = C(opt_C_idx);

% -------------------------------------------------------------
% estimate the model using optiomal C
% -------------------------------------------------------------
% construct the training data

option_liblinear = ['-w+1 ', num2str(weight), ' -w-1 1 -c ', num2str(opt_C), ' -s 1 -q'];
model = train(trn.y, sparse(trn.X), option_liblinear);

[~, ~, decPos] = predict(ones(size(trainPositiveData,2),1), sparse(trainPositiveData'), model);
[~, ~, decNeg] = predict(-ones(size(trainNegativeData,2),1), sparse(trainNegativeData'), model);

[~, ~, decValPos] = predict(ones(size(valPositiveData,2),1), sparse(valPositiveData'), model);
[~, ~, decValNeg] = predict(-ones(size(valNegativeData,2),1), sparse(valNegativeData'), model);

%--------------------------------------------------------------
% apply model to the test data
%--------------------------------------------------------------
decValuesPosiTest = [];
decValuesNegaTest = [];
tempPosiTest =[];
tempNageTest = [];
for n =1:size(testPositiveList,1)
    testPositiveData = load(testPositiveList{n}');
    [~, ~, tempPosiTest] = predict(ones(size(testPositiveData.segment,2), 1), sparse(testPositiveData.segment'), model);
    decValuesPosiTest = [decValuesPosiTest; tempPosiTest'];
end

for n =1:size(testNegativeList,1)
    testNegativeData = load(testNegativeList{n}');
    [~, ~, tempNegaTest] = predict(-ones(size(testNegativeData.segment,2), 1), sparse(testNegativeData.segment'), model);
    decValuesNegaTest = [decValuesNegaTest; tempNegaTest'];
end


% %--------------------------------------------------------------
% % save results
% %--------------------------------------------------------------
% 
% path_to_save = [pathToResults dogID_abbrev{d} '_online/'];
% if ~exist(path_to_save, 'dir')
%     mkdir([pathToResults dogID_abbrev{d} '_online/']);
% end
% 
%     save([path_to_save dogID_abbrev{d} '_online_' num2str(round, '%02d') '_' method{m} '_' datestr(expDate, 29) '.mat'], ...
%         'opt_C', ...
%         'validAcc', ...
%         'decValuesPreExtra', ...
%         'decValuesIntExtra', ...
%         'ReadableInterStart', ...
%         'ReadableInterEnd', ...
%         'ReadableSeizureStart', ...
%         'ReadableSeizureEnd', ...
%         'InterictalInfo', ...
%         'PreictalInfo', ...
%         'preFileList', ...
%         'interFileList', ...
%         'trainPreFileList', ...
%         'trainInterFileList', ...
%         'decPre', ...
%         'decInt', ...
%         'inPoolInterSerial', ...
%         'inPoolPreSerial', ...
%         'retrainPeriod', ...
%         'scalingMethod', ...
%         'leadSeizureRule', ...
%         'A', 'B', 'E1', 'E2');



