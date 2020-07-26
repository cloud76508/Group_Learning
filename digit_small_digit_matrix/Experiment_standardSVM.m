clear all;
close all;
clc;
sample_size = 20;
[trainPositiveData, trainNegativeData, valPositiveData,...
    valNegativeData, testPositiveData, testNegativeData] = loadData_standardSVM(sample_size, sample_size, 500);


trn.X = [trainNegativeData';trainPositiveData'];
trn.y = [-ones(size(trainNegativeData,2),1);ones(size(trainPositiveData,2),1)];
%trn.y = [randlabel(size(trainNegativeData,2));randlabel(size(trainPositiveData,2))];

val.X = [valNegativeData'; valPositiveData'];
val.y = [-ones(size(valNegativeData,2),1);ones(size(valPositiveData,2),1)];
%val.y = [randlabel(size(valNegativeData,2));randlabel(size(valPositiveData,2))];


% C parameter of SVM
C = 10.^(-4:1:4);
%C = 10.^(-1:1:1);


for idx = 1:size(C, 2)
    option_liblinear = [' -c ', num2str(C(idx)), ' -s 1 -q'];
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

option_liblinear = ['-c ', num2str(opt_C), ' -s 1 -q'];
model = train(trn.y, sparse(trn.X), option_liblinear);

fprintf('------------------------------------------------------------\n')
fprintf('training results:\n')
fprintf('True positive:\n')
[~, ~, decPos] = predict(ones(size(trainPositiveData,2),1), sparse(trainPositiveData'), model);
fprintf('True negative:\n')
[~, ~, decNeg] = predict(-ones(size(trainNegativeData,2),1), sparse(trainNegativeData'), model);
fprintf('------------------------------------------------------------\n')

fprintf('------------------------------------------------------------\n')
fprintf('validation results:\n')
fprintf('True positive:\n')
[~, ~, decValPos] = predict(ones(size(valPositiveData,2),1), sparse(valPositiveData'), model);
fprintf('True negative:\n')
[~, ~, decValNeg] = predict(-ones(size(valNegativeData,2),1), sparse(valNegativeData'), model);
fprintf('------------------------------------------------------------\n')

%--------------------------------------------------------------
% apply model to the test data
%--------------------------------------------------------------
decValuesPosiTest = [];
decValuesNegaTest = [];

fprintf('------------------------------------------------------------\n')
fprintf('test results:\n')
fprintf('True positive:\n')
[~, ~, tempPosiTest] = predict(ones(size(testPositiveData,2), 1), sparse(testPositiveData'), model);
%[~, ~, tempPosiTest] = predict(randlabel(size(testPositiveData,2)), sparse(testPositiveData'), model);
decValuesPosiTest = [decValuesPosiTest; tempPosiTest'];

fprintf('True negative:\n')
[~, ~, tempNegaTest] = predict(-ones(size(testNegativeData,2), 1), sparse(testNegativeData'), model);
%[~, ~, tempNegaTest] = predict(randlabel(size(testNegativeData,2)), sparse(testNegativeData'), model);
decValuesNegaTest = [decValuesNegaTest; tempNegaTest'];
fprintf('------------------------------------------------------------\n')


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



