clear all;
close all;
clc;
sample_size = 15;
[trainPositiveData, trainNegativeData, valPositiveData,...
    valNegativeData, testPositiveData, testNegativeData] = loadData_standardSVM(sample_size, sample_size,sample_size, 500);


trn.X = [trainNegativeData';trainPositiveData'];
trn.y = [-ones(size(trainNegativeData,2),1);ones(size(trainPositiveData,2),1)];
 
% trn.X = [trainNegativeData';trainNegativeData';trainNegativeData';trainNegativeData';trainNegativeData';...
%     trainNegativeData';trainNegativeData';trainNegativeData';trainNegativeData';trainNegativeData';...
%     trainPositiveData'; trainPositiveData'; trainPositiveData'; trainPositiveData'; trainPositiveData';...
%     trainPositiveData'; trainPositiveData'; trainPositiveData'; trainPositiveData'; trainPositiveData'];
% trn.y = [-ones(size(trainNegativeData,2)*10,1);ones(size(trainPositiveData,2)*10,1)];

val.X = [valNegativeData'; valPositiveData'];
val.y = [-ones(size(valNegativeData,2),1);ones(size(valPositiveData,2),1)];

% val.X = [valNegativeData';valNegativeData';valNegativeData';valNegativeData';valNegativeData';...
%     valNegativeData';valNegativeData';valNegativeData';valNegativeData';valNegativeData';...
%     valPositiveData'; valPositiveData'; valPositiveData'; valPositiveData'; valPositiveData';...
%     valPositiveData'; valPositiveData'; valPositiveData'; valPositiveData'; valPositiveData'];
% val.y = [-ones(size(valNegativeData,2)*10,1);ones(size(valPositiveData,2)*10,1)];


% C parameter of SVM
C = 10.^(-4:1:4);
%C = 2.^(-4:1:4);

crossValAccuracy =[];
weight = 1;
for idx = 1:size(C, 2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% liblinear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     option_liblinear = ['-w+1 ', num2str(weight), ' -w-1 1 -c ', num2str(C(idx)), ' -s 1 -q'];
%     mdl = train(trn.y, sparse(trn.X), option_liblinear);
%     %%% ----- do this -----
%     [pred, ~, ~] = predict(val.y, sparse(val.X), mdl);
%     crossValAccuracy(idx) = sum(pred == val.y) / length(val.y);
%     %%% ----- or specify a 'validation function' in do_binary_predict()
%     %[pred, crossValAccuracy(idx), dec] = do_binary_predict(val.y, sparse(val.X), mdl);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%libsvm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    option_liblinear = ['-c ', num2str(C(idx)), ' -s 0 -h 0'];
    mdl = svmtrain(trn.y, sparse(trn.X), option_liblinear);
    [pred, ~, dec] = svmpredict(val.y, val.X, mdl);
    crossValAccuracy(idx) = sum(pred == val.y) / length(val.y);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %liblinear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% option_liblinear = ['-w+1 ', num2str(weight), ' -w-1 1 -c ', num2str(opt_C), ' -s 1 -q'];
% model = train(trn.y, sparse(trn.X), option_liblinear);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%libsvm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
option_liblinear = ['-c ', num2str(C(idx)), ' -s 0'];
model = svmtrain(trn.y, trn.X, option_liblinear);

fprintf('------------------------------------------------------------\n')
fprintf('training results:\n')
fprintf('True positive:\n')
%[~, ~, decPos] = predict(ones(size(trainPositiveData,2),1), sparse(trainPositiveData'), model);
[~, ~, decPos] = svmpredict(ones(size(trainPositiveData,2),1), trainPositiveData', model);
fprintf('True negative:\n')
%[~, ~, decNeg] = predict(-ones(size(trainNegativeData,2),1), sparse(trainNegativeData'), model);
[~, ~, decPos] = svmpredict(ones(size(trainPositiveData,2),1), trainPositiveData', model);
fprintf('------------------------------------------------------------\n')

fprintf('------------------------------------------------------------\n')
fprintf('validation results:\n')
fprintf('True positive:\n')
%[~, ~, decValPos] = predict(ones(size(valPositiveData,2),1), sparse(valPositiveData'), model);
[~, ~, decValPos] = svmpredict(ones(size(valPositiveData,2),1), valPositiveData', model);
fprintf('True negative:\n')
%[~, ~, decValNeg] = predict(-ones(size(valNegativeData,2),1), sparse(valNegativeData'), model);
[~, ~, decValNeg] = svmpredict(-ones(size(valNegativeData,2),1), valNegativeData', model);
fprintf('------------------------------------------------------------\n')

%--------------------------------------------------------------
% apply model to the test data
%--------------------------------------------------------------
decValuesPosiTest = [];
decValuesNegaTest = [];

fprintf('------------------------------------------------------------\n')
fprintf('test results:\n')
fprintf('True positive:\n')
%[~, ~, tempPosiTest] = predict(ones(size(testPositiveData,2), 1), sparse(testPositiveData'), model);
[~, ~, tempPosiTest] = svmpredict(ones(size(testPositiveData,2), 1), testPositiveData', model);
decValuesPosiTest = [decValuesPosiTest; tempPosiTest'];

fprintf('True negative:\n')
%[~, ~, tempNegaTest] = predict(-ones(size(testNegativeData,2), 1), sparse(testNegativeData'), model);
[~, ~, tempNegaTest] = svmpredict(-ones(size(testNegativeData,2), 1),testNegativeData', model);
decValuesNegaTest = [decValuesNegaTest; tempNegaTest'];
fprintf('------------------------------------------------------------\n')

1-(sum(tempPosiTest>0) + sum(tempNegaTest<0))/1000

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



