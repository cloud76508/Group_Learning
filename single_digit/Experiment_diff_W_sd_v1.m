clear all;
clc;

%window_size_list = [20,23,24,25,26,27];
window_size_list = [10,15,20,25];

for w = 1:length(window_size_list)
    clearvars -except window_size_list w
    sample_size = 5; %number of valdiation data in each classes
    test_size = 500;
    window_size = window_size_list(w);
    
    [trainPositiveData, trainNegativeData, valPositiveData,...
        valNegativeData,testPositiveList, testNegativeList]  = loadData(sample_size,sample_size, sample_size, test_size);
    %segmentation in the same way as CNN (i.e., segmentation_for_CNN)
    %display_network(reshape(segment,[],1))
    
    size_seg = size(trainPositiveData,1);
    
    train_pos = [];
    train_neg = [];
    val_pos = [];
    val_neg = [];
    for n=1:sample_size
        eachData = trainPositiveData(:,(n-1)*size_seg+1:n*size_seg);
        [~,window_data] = partition_sd_v1(eachData,window_size);
        train_pos = [train_pos,window_data];
        
        eachData = trainNegativeData(:,(n-1)*size_seg+1:n*size_seg);
        [~,window_data] = partition_sd_v1(eachData,window_size);
        train_neg = [train_neg,window_data];
        
        eachData = valPositiveData(:,(n-1)*size_seg+1:n*size_seg);
        [~,window_data] = partition_sd_v1(eachData,window_size);
        val_pos = [val_pos,window_data];
        
        eachData = valNegativeData(:,(n-1)*size_seg+1:n*size_seg);
        [~,window_data] = partition_sd_v1(eachData,window_size);
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
    
    % weight parameter of SVM
    weight = 1;
    
    for idx = 1:size(C, 2)
%         option_liblinear = ['-w+1 ', num2str(weight), ' -w-1 1 -c ', num2str(C(idx)), ' -s 1 -q'];
%         mdl = train(trn.y, sparse(trn.X), option_liblinear);
%         
%         %%% ----- do this -----
%         [pred, ~, ~] = predict(val.y, sparse(val.X), mdl);
%         crossValAccuracy(idx) = sum(pred == val.y) / length(val.y);
%         
%         %%% ----- or specify a 'validation function' in do_binary_predict()
%         %[pred, crossValAccuracy(idx), dec] = do_binary_predict(val.y, sparse(val.X), mdl);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %libsvm
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        option_liblinear = ['-c ', num2str(C(idx)), ' -s 0'];
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
    
%     [~, ~, decPos] = predict(ones(size(trainPositiveData,2),1), sparse(trainPositiveData'), model);
%     [~, ~, decNeg] = predict(-ones(size(trainNegativeData,2),1), sparse(trainNegativeData'), model);
%     
%     [~, ~, decValPos] = predict(ones(size(valPositiveData,2),1), sparse(valPositiveData'), model);
%     [~, ~, decValNeg] = predict(-ones(size(valNegativeData,2),1), sparse(valNegativeData'), model);
    [~, ~, decPos] = svmpredict(ones(size(trainPositiveData,2),1), trainPositiveData', model);
    [~, ~, decNeg] = svmpredict(-ones(size(trainNegativeData,2),1),trainNegativeData', model);
    
    [~, ~, decValPos] = svmpredict(ones(size(valPositiveData,2),1), valPositiveData', model);
    [~, ~, decValNeg] = svmpredict(-ones(size(valNegativeData,2),1), valNegativeData', model);
    
    %--------------------------------------------------------------
    % apply model to the test data
    %--------------------------------------------------------------
    decValuesPosiTest = [];
    decValuesNegaTest = [];
    tempPosiTest =[];
    tempNageTest = [];
    for n =1:size(testPositiveList,1)
        temp_data = load(testPositiveList{n});
        [number_windows,testPositiveData] = partition_sd_v1(temp_data.segment,window_size);
        
        %[~, ~, tempPosiTest] = predict(ones(size(testPositiveData,2),1), sparse(testPositiveData'), model);
        [~, ~, tempPosiTest] = svmpredict(ones(size(testPositiveData,2),1), testPositiveData', model);
        decValuesPosiTest = [decValuesPosiTest; tempPosiTest'];
        
    end
    
    for n =1:size(testNegativeList,1)
        temp_data = load(testNegativeList{n}');
        [number_windows,testNegativeData] = partition_sd_v1(temp_data.segment,window_size);
        
        
        %[~, ~, tempNegaTest] = predict(-ones(size(testNegativeData,2),1), sparse(testNegativeData'), model);
        [~, ~, tempNegaTest] = svmpredict(-ones(size(testNegativeData,2),1), testNegativeData', model);
        decValuesNegaTest = [decValuesNegaTest; tempNegaTest'];
        
    end
    
    
    % %--------------------------------------------------------------
    % % save results
    % %--------------------------------------------------------------
    pathToResults = 'C:\Users\ASUS\Documents\GitHub\Group_Learning\single_digit\Results\';
    fileName = sprintf('SVM_GL_W%d_v1.mat',window_size_list(w));
    path_to_save = [pathToResults fileName];
    save(path_to_save)
end