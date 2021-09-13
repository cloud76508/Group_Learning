function [training_error, test_error]  = SVM_GL_adaptive_fixed_C(w)
    clearvars -except window_size_list w
    sample_size = 5; %number of valdiation data in each classes
    test_size = 500;
    window_size = w;
    
    [trainPositiveData, trainNegativeData, valPositiveData,...
        valNegativeData,testPositiveList, testNegativeList]  = loadData(sample_size,sample_size, sample_size, test_size);
    %segmentation in the same way as CNN (i.e., segmentation_for_CNN)
    %display_network(reshape(segment,[],1))
    
    size_seg = size(trainPositiveData,1);
    
    train_pos = [];
    train_neg = [];
    for n=1:sample_size
        eachData = trainPositiveData(:,(n-1)*size_seg+1:n*size_seg);
        [~,window_data] = partition_grid(eachData,window_size);
        train_pos = [train_pos,window_data];
        
        eachData = trainNegativeData(:,(n-1)*size_seg+1:n*size_seg);
        [~,window_data] = partition_grid(eachData,window_size);
        train_neg = [train_neg,window_data];
    end
    
    trainPositiveData = train_pos;
    trainNegativeData = train_neg;

    trn.X = [trainNegativeData';trainPositiveData'];
    trn.y = [-ones(size(trainNegativeData,2),1);ones(size(trainPositiveData,2),1)];
    
    % C parameter of SVM
    %C = 10.^(-4:1:4);
    C = 10000;
    
    % weight parameter of SVM
    weight = 1;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %libsvm
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    option_liblinear = ['-c ', num2str(C), ' -s 0'];
    model = svmtrain(trn.y, trn.X, option_liblinear);
    
    [~, ~, decPos] = svmpredict(ones(size(trainPositiveData,2),1), trainPositiveData', model);
    [~, ~, decNeg] = svmpredict(-ones(size(trainNegativeData,2),1),trainNegativeData', model);
    
    %--------------------------------------------------------------
    % apply model to the test data
    %--------------------------------------------------------------
    decValuesPosiTest = [];
    decValuesNegaTest = [];
    tempPosiTest =[];
    tempNageTest = [];
    for n =1:size(testPositiveList,1)
        temp_data = load(testPositiveList{n});
        [number_windows,testPositiveData] = partition_grid(temp_data.segment,window_size);
        
        %[~, ~, tempPosiTest] = predict(ones(size(testPositiveData,2),1), sparse(testPositiveData'), model);
        [~, ~, tempPosiTest] = svmpredict(ones(size(testPositiveData,2),1), testPositiveData', model);
        decValuesPosiTest = [decValuesPosiTest; tempPosiTest'];        
    end
    
    for n =1:size(testNegativeList,1)
        temp_data = load(testNegativeList{n});
        [~,testNegativeData] = partition_grid(temp_data.segment,window_size);
        
        %[~, ~, tempNegaTest] = predict(-ones(size(testNegativeData,2),1), sparse(testNegativeData'), model);
        [~, ~, tempNegaTest] = svmpredict(-ones(size(testNegativeData,2),1), testNegativeData', model);
        decValuesNegaTest = [decValuesNegaTest; tempNegaTest'];      
    end
    
    number_windows = size(decValuesPosiTest,2);

    decNeg = reshape(decNeg,number_windows,[]);
    decPos = reshape(decPos,number_windows,[]);

    decValuesNegaTest = decValuesNegaTest';
    decValuesPosiTest = decValuesPosiTest';
    
    thr1 = (quantile(mean(decNeg),0.5) + quantile(mean(decPos),0.5))/2;
    training_error = 1- (sum(mean(decPos) > thr1) + sum(mean(decNeg) <= thr1))/(size(decNeg,2)+size(decPos,2));
    test_error = 1- (sum(mean(decValuesPosiTest) > thr1) + sum(mean(decValuesNegaTest) <= thr1))/(size(decValuesNegaTest,2)+size(decValuesPosiTest,2));
end