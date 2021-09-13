function [training_error, test_error]  = SVM_GL_MV(w)
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
    option_liblinear = ['-c ', num2str(AAAAAAAAAAC), ' -s 0'];
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
        temp_data = load(testNegativeList{n}');
        [~,testNegativeData] = partition_grid(temp_data.segment,window_size);

        %[~, ~, tempNegaTest] = predict(-ones(size(testNegativeData,2),1), sparse(testNegativeData'), model);
        [~, ~, tempNegaTest] = svmpredict(-ones(size(testNegativeData,2),1), testNegativeData', model);
        decValuesNegaTest = [decValuesNegaTest; tempNegaTest'];
    end

    number_windows = size(decValuesPosiTest,2);
    decNeg = reshape(decNeg,number_windows,[]);
    decPos = reshape(decPos,number_windows,[]);
    decValuesIntTest = decValuesNegaTest';
    decValuesPreTest = decValuesPosiTest';

    %mtehod 2 Majority vote
    FN = 0;
    for n = 1:size(decValuesPreTest,2)
        positiveVote = sum(decValuesPreTest(:,n) > 0);
        negativeVote = sum(decValuesPreTest(:,n) < 0);
        if negativeVote >  positiveVote
            FN = FN +1;
        elseif  positiveVote == negativeVote
            randomNum = randperm(2);
            FN = FN + randomNum(1)-1;
        end
    end

    FP = 0;
    for n = 1:size(decValuesIntTest,2)
        positiveVote = sum(decValuesIntTest(:,n) > 0);
        negativeVote = sum(decValuesIntTest(:,n) < 0);
        if positiveVote > negativeVote
            FP = FP +1;
        elseif  positiveVote == negativeVote
            randomNum = randperm(2);
            FP = FP + randomNum(1)-1;        
        end
    end

    %mtehod 2 Majority vote
    FN_train = 0;
    for n = 1:size(decPos,2)
        positiveVote = sum(decPos(:,n) > 0);
        negativeVote = sum(decPos(:,n) < 0);
        if negativeVote > positiveVote
            FN_train = FN_train +1;
        elseif  positiveVote == negativeVote
            randomNum = randperm(2);
            FN_train = FN_train + randomNum(1)-1;
        end
    end

    FP_train = 0;
    for n = 1:size(decNeg,2)
        positiveVote = sum(decNeg(:,n) > 0);
        negativeVote = sum(decNeg(:,n) < 0);
        if positiveVote > negativeVote
            FP_train = FP_train +1;
        elseif  positiveVote == negativeVote
            randomNum = randperm(2);
            FP_train = FP_train + randomNum(1)-1;
        end
    end

    training_error = (FN_train+FP_train)/(size(decPos,2)+size(decPos,2));
    test_error = (FP+FN)/(size(decValuesPreTest,2)+size(decValuesIntTest,2));
end