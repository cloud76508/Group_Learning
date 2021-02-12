clear all;
clc;

window_size_list = [7,14,20,25,28,30,35,40,45,50,56,112];
%window_size_list = [20,25,28,30,35,40];

for w = 1:length(window_size_list)
    clearvars -except window_size_list w
    sample_size = 10; %number of valdiation data in each classes
    test_size = 500;
    window_size = window_size_list(w);
    
    [trainPositiveData, trainNegativeData, valPositiveData,...
        valNegativeData,testPositiveList, testNegativeList]  = loadData(10,10, 10, test_size);
    %segmentation in the same way as CNN (i.e., segmentation_for_CNN)
    %display_network(reshape(segment,[],1))
    
    size_seg = size(trainPositiveData,1);
    
    train_pos = [];
    train_neg = [];
    val_pos = [];
    val_neg = [];
    for n=1:sample_size
        eachData = trainPositiveData(:,(n-1)*size_seg+1:n*size_seg);
        [~,window_data] = partition_FP(eachData,window_size);
        train_pos = [train_pos,window_data];
        
        eachData = trainNegativeData(:,(n-1)*size_seg+1:n*size_seg);
        [~,window_data] = partition_FP(eachData,window_size);
        train_neg = [train_neg,window_data];
        
        eachData = valPositiveData(:,(n-1)*size_seg+1:n*size_seg);
        [~,window_data] = partition_FP(eachData,window_size);
        val_pos = [val_pos,window_data];
        
        eachData = valNegativeData(:,(n-1)*size_seg+1:n*size_seg);
        [~,window_data] = partition_FP(eachData,window_size);
        val_neg = [val_neg,window_data];
    end
    
    trainPositiveData = train_pos;
    trainNegativeData = train_neg;
    valPositiveData = val_pos;
    valNegativeData = val_neg;
    
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
        temp_data = load(testPositiveList{n});
        [number_windows,testPositiveData] = partition_FP(temp_data.segment,window_size);
        
        [~, ~, tempPosiTest] = predict(ones(size(testPositiveData,2),1), sparse(testPositiveData'), model);
        decValuesPosiTest = [decValuesPosiTest; tempPosiTest'];
        
    end
    
    for n =1:size(testNegativeList,1)
        temp_data = load(testNegativeList{n}');
        [number_windows,testNegativeData] = partition_FP(temp_data.segment,window_size);
        
        
        [~, ~, tempNegaTest] = predict(-ones(size(testNegativeData,2),1), sparse(testNegativeData'), model);
        decValuesNegaTest = [decValuesNegaTest; tempNegaTest'];
        
    end
    
    
    % %--------------------------------------------------------------
    % % save results
    % %--------------------------------------------------------------
    pathToResults = 'C:\Users\ASUS\Documents\GitHub\Group_Learning\digit_digit_matrix_64\Results\';
    fileName = sprintf('SVM_GL_W%d.mat',window_size_list(w));
    path_to_save = [pathToResults fileName];
    save(path_to_save)
    
end