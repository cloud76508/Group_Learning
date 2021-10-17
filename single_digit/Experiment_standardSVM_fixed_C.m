function [training_error, test_error]  = Experiment_standardSVM_fixed_C(c_parameter)
    sample_size = 5;
    [trainPositiveData, trainNegativeData, valPositiveData,...
        valNegativeData, testPositiveData, testNegativeData] = loadData_standardSVM(sample_size, sample_size,sample_size, 500);


    trn.X = [trainNegativeData';trainPositiveData'];
    trn.y = [-ones(size(trainNegativeData,2),1);ones(size(trainPositiveData,2),1)];

    weight = 1;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % %liblinear
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % option_liblinear = ['-w+1 ', num2str(weight), ' -w-1 1 -c ', num2str(opt_C), ' -s 1 -q'];
    % model = train(trn.y, sparse(trn.X), option_liblinear);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %libsvm
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    option_liblinear = ['-c ', num2str(c_parameter), ' -s 0'];
    model = svmtrain(trn.y, trn.X, option_liblinear);
    
    %default_liblinear = ['-s 0'];
    %model = svmtrain(trn.y, trn.X, default_liblinear);
    
    fprintf('------------------------------------------------------------\n')
    fprintf('training results:\n')
    fprintf('True positive:\n')
    %[~, ~, decPos] = predict(ones(size(trainPositiveData,2),1), sparse(trainPositiveData'), model);
    [~, ~, decPos] = svmpredict(ones(size(trainPositiveData,2),1), trainPositiveData', model);
    fprintf('True negative:\n')
    %[~, ~, decNeg] = predict(-ones(size(trainNegativeData,2),1), sparse(trainNegativeData'), model);
    [~, ~, decNeg] = svmpredict(-ones(size(trainNegativeData,2),1), trainNegativeData', model);
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

    test_error = 1-(sum(tempPosiTest>0) + sum(tempNegaTest<0))/1000;
end