clear all;
close all;
clc;
%loadData
loadData_balanced


setFold = 5;

sizeNegFold = size(trainNegativeData,2)/setFold;
sizePosFold = size(trainPositiveData,2)/setFold;

for fold = 1:setFold
    learnNeg = trainNegativeData;
    learnNeg(:,(fold-1)*sizeNegFold+1:fold*sizeNegFold) = [];
    
    learnPos = trainPositiveData;
    learnPos(:,(fold-1)*sizePosFold+1:fold*sizePosFold) = [];
    
    learn.X = [learnNeg'; learnPos'];
    learn.y = [-ones(size(learnNeg,2),1);ones(size(learnPos,2),1)];
    
    valNeg = trainNegativeData(:,(fold-1)*sizeNegFold+1:fold*sizeNegFold);
    valPos = trainPositiveData(:,(fold-1)*sizePosFold+1:fold*sizePosFold);
    val.X = [valNeg'; valPos'];
    val.y = [-ones(size(valNeg,2),1);ones(size(valPos,2),1)];
    
    % C parameter of SVM
    C = 10.^(-4:1:4);
    %C = 10.^(-1:1:1);
    
    % weight parameter of SVM
    weight = 1;
    
    for idx = 1:size(C, 2)
        option_liblinear = ['-w+1 ', num2str(weight), ' -w-1 1 -c ', num2str(C(idx)), ' -s 1 -q'];
        mdl = train(learn.y, sparse(learn.X), option_liblinear);
        
%         [pred, ~, ~] = predict(val.y, sparse(val.X), mdl);
%         crossValAccuracy(idx, fold) = sum(pred == val.y) / length(val.y);  
        
        %%% ----- or specify a 'validation function' in do_binary_predict()
        [pred, crossValAccuracy(idx,fold), dec] = do_binary_predict(val.y, sparse(val.X), mdl);
    end
    
end

%clear learn val;

% -------------------------------------------------------------
% find the optimal C
% -------------------------------------------------------------
[validAcc, opt_C_idx] = max(mean(crossValAccuracy, 2));
opt_C = C(opt_C_idx);

% -------------------------------------------------------------
% estimate the model using optiomal C
% -------------------------------------------------------------
% construct the training data
trn.X = [trainNegativeData';trainPositiveData'];
trn.y = [-ones(size(trainNegativeData,2),1);ones(size(trainPositiveData,2),1)];

option_liblinear = ['-w+1 ', num2str(weight), ' -w-1 1 -c ', num2str(opt_C), ' -s 1 -q'];
model = train(trn.y, sparse(trn.X), option_liblinear);
[~, ~, decPos] = predict(ones(size(trainPositiveData,2),1), sparse(trainPositiveData'), model);
[~, ~, decNeg] = predict(-ones(size(trainNegativeData,2),1), sparse(trainNegativeData'), model);


%--------------------------------------------------------------
% apply model to the test data
%--------------------------------------------------------------
decValuesPreTest = [];
decValuesIntTest = [];

[~, ~, decValuesPreTest] = predict(ones(size(testPositiveData,2), 1), sparse(testPositiveData'), model);
[~, ~, decValuesIntTest] = predict(-ones(size(testNegativeData,2), 1), sparse(testNegativeData'), model);

clc

fprintf('SS(training) = %d\n', sum(decPos>0)/length(decPos))
fprintf('SP(training) = %d\n', sum(decNeg<0)/length(decNeg))

fprintf('SS(test) = %d\n', sum(decValuesPreTest>0)/length(decValuesPreTest))
fprintf('SP(test) = %d\n', sum(decValuesIntTest<0)/length(decValuesIntTest))


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



