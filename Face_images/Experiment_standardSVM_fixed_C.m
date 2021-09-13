function [training_error, test_error]  = Experiment_standardSVM_fixed_C(c_parameter)
    sample_size = 10;
    [trainPositiveData, trainNegativeData, valPositiveData,...
        valNegativeData, testPositiveData, testNegativeData] = loadData_standardSVM(sample_size, sample_size,sample_size, 24);

    trn.X = [trainNegativeData';trainPositiveData'];
    trn.y = [-ones(size(trainNegativeData,2),1);ones(size(trainPositiveData,2),1)];

    option_liblinear = ['-c ', num2str(c_parameter), ' -s 0'];
    model = svmtrain(trn.y, trn.X, option_liblinear);

    fprintf('------------------------------------------------------------\n')
    fprintf('training results:\n')
    fprintf('True positive:\n')
    %[~, ~, decPos] = predict(ones(size(trainPositiveData,2),1), sparse(trainPositiveData'), model);
    [~, ~, decPos] = svmpredict(ones(size(trainPositiveData,2),1), trainPositiveData', model);
    fprintf('True negative:\n')
    %[~, ~, decNeg] = predict(-ones(size(trainNegativeData,2),1), sparse(trainNegativeData'), model);
    [~, ~, decNeg] = svmpredict(-ones(size(trainNegativeData,2),1), trainNegativeData', model);
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

    training_error = 1-(sum(decPos>0) + sum(decNeg<0))/(sample_size*2);
    test_error = 1-(sum(tempPosiTest>0) + sum(tempNegaTest<0))/88;
end