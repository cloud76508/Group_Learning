clear all;
close all;
clc;

loadData

[rawData,maxV,minV] = normalization(rawData,1);

for n =1:length(label)
    if label(n) ==0
        label(n) = -1;
    end
end

originLabel = label;

groupSize = [5,7,9,11,13,15];

decPos = [];
decNeg = [];
decTest = [];
OptimalGS = [];
OptimalC = [];

decPos = {};
decNeg = {};
decTest = {};

for n = 1:12
    groupValACC = [];
    for gs = 1:length(groupSize) %group size index for group learning
        %cut some features for performing group learning
        remainder = mod(size(rawData,2),groupSize(gs));
        roudData = rawData(:, 1:end-remainder);
        groupData = [];
        for j =1:size(roudData,1)
            groupData = [groupData; reshape(roudData(j,:), [],groupSize(gs))'];
        end
        
        groupLabel = [ones(sum(originLabel == 1)*groupSize(gs),1);-ones(sum(originLabel == -1)*groupSize(gs),1)];
        
        roudData = groupData;
        label = groupLabel;
        
        crossValAccuracy = [];
        
        %tstResults = [];
        weight = 1;
        %weight = 0.1875;
        
        positiveData = roudData(label==1,:);
        negativeData = roudData(label==-1,:);
        positiveLabel = label(label==1,:);
        negativeLabel = label(label==-1,:);
        
        %         test.X = [positiveData((n-1)*groupSize+1:n*groupSize,:);negativeData((n-1)*groupSize+1:n*groupSize,:)];
        %         test.y = [positiveLabel((n-1)*groupSize+1:n*groupSize,:);negativeLabel((n-1)*groupSize+1:n*groupSize,:)];
        
        trainPos = positiveData;
        trainPos((n-1)*groupSize(gs)+1:n*groupSize(gs),:) =[];
        trainPosLab = ones(size(trainPos,1),1);
        trainNeg = negativeData;
        trainNeg((n-1)*groupSize(gs)+1:n*groupSize(gs),:) =[];
        trainNegLab = -ones(size(trainNeg,1),1);
        
        trainSet.X = [trainPos;trainNeg];
        trainSet.y = [trainPosLab;trainNegLab];
        
        setFold = sum(trainSet.y == 1)/groupSize(gs);
        
        for fold = 1:setFold
            learnNeg = trainNeg;
            learnNeg((fold-1)*groupSize+1:fold*groupSize,:) = [];
            learnPos = trainPos;
            learnPos((fold-1)*groupSize+1:fold*groupSize,:) = [];
            learn.X = [learnPos;learnNeg];
            learn.y = [ones(size(learnPos,1),1);-ones(size(learnNeg,1),1)];
            
            valNeg = trainNeg((fold-1)*groupSize+1:fold*groupSize,:);
            valPos = trainPos((fold-1)*groupSize+1:fold*groupSize,:);
            val.X = [valPos; valNeg];
            val.y = [ones(size(valPos,1),1);-ones(size(valNeg,1),1)];
            
            % C parameter of SVM
            C = 10.^(-4:1:4);
            
            for idx = 1:size(C, 2)
                option_liblinear = ['-w+1 ', num2str(weight), ' -w-1 1 -c ', num2str(C(idx)), ' -s 1 -q'];
                mdl = train(learn.y, sparse(learn.X), option_liblinear);
                
                [pred, ~, ~] = predict(val.y, sparse(val.X), mdl);
                crossValAccuracy(idx, fold) = sum(pred == val.y) / length(val.y);
                
                %%% ----- or specify a 'validation function' in do_binary_predict()
                % [pred, crossValAccuracy(idx,fold), dec] = do_binary_predict(val.y, sparse(val.X), mdl);
            end
        end
        
        
        groupValACC(:,gs) = mean(crossValAccuracy, 2);
        
    end
    
    % -------------------------------------------------------------
    % find the optimal C
    % -------------------------------------------------------------
    [validAcc, opt_C_idx] = max(mean(crossValAccuracy, 2));
    opt_C = C(opt_C_idx);
    
    [~, opt_GS_idx] = max(max(groupValACC));
    [~, opt_C_idx] = max(groupValACC(:,opt_GS_idx));
    opt_GS = groupSize(opt_GS_idx);
    opt_C = C(opt_C_idx);
    OptimalGS(n,1) = opt_GS;
    OptimalC(n,1) = opt_C;
    
    % -------------------------------------------------------------
    % build training & test data using optimal group size
    % -------------------------------------------------------------
    
    %cut some features for performing group learning
    remainder = mod(size(rawData,2),groupSize(opt_GS_idx));
    roudData = rawData(:, 1:end-remainder);
    groupData = [];
    for j =1:size(roudData,1)
        groupData = [groupData; reshape(roudData(j,:), [],groupSize(opt_GS_idx))'];
    end
    
    groupLabel = [ones(sum(originLabel == 1)*groupSize(opt_GS_idx),1);-ones(sum(originLabel == -1)*groupSize(opt_GS_idx),1)];
    
    roudData = groupData;
    label = groupLabel;
    
    weight = 1;
    
    positiveData = roudData(label==1,:);
    negativeData = roudData(label==-1,:);
    positiveLabel = label(label==1,:);
    negativeLabel = label(label==-1,:);
    
    test.X = [positiveData((n-1)*groupSize(opt_GS_idx)+1:n*groupSize(opt_GS_idx),:);negativeData((n-1)*groupSize(opt_GS_idx)+1:n*groupSize(opt_GS_idx),:)];
    test.y = [positiveLabel((n-1)*groupSize(opt_GS_idx)+1:n*groupSize(opt_GS_idx),:);negativeLabel((n-1)*groupSize(opt_GS_idx)+1:n*groupSize(opt_GS_idx),:)];
    
    trainPos = positiveData;
    trainPos((n-1)*groupSize(opt_GS_idx)+1:n*groupSize(opt_GS_idx),:) =[];
    trainPosLab = ones(size(trainPos,1),1);
    trainNeg = negativeData;
    trainNeg((n-1)*groupSize(opt_GS_idx)+1:n*groupSize(opt_GS_idx),:) =[];
    trainNegLab = -ones(size(trainNeg,1),1);
    
    trainSet.X = [trainPos;trainNeg];
    trainSet.y = [trainPosLab;trainNegLab];
    
    % -------------------------------------------------------------
    % estimate the model using optiomal C
    % -------------------------------------------------------------
    option_liblinear = ['-w+1 ', num2str(weight), ' -w-1 1 -c ', num2str(opt_C), ' -s 1 -q'];
    model = train(trainSet.y, sparse(trainSet.X), option_liblinear);
    
    % outputs for training data
    [~, ~, decPos{n,1}] = predict(ones(size(trainPos,1),1), sparse(trainPos), model);
    [~, ~, decNeg{n,1}] = predict(-ones(size(trainNeg,1),1), sparse(trainNeg), model);
     % outputs for test data
    [~, ~, decTest{n,1}] = predict(test.y, sparse(test.X), model);
    
    %     [~, ~, decPos(:,n)] = do_binary_predict(ones(size(trainPos,1),1), sparse(trainPos), model);
    %     [~, ~, decNeg(:,n)] = do_binary_predict(-ones(size(trainNeg,1),1), sparse(trainNeg), model);
    %     [~, ~, decTest(:,n)] = do_binary_predict(test.y, sparse(test.X), model);
    
    %     decNeg = reshape(decNeg,groupSize,[])';
    %     decPos = reshape(decPos,groupSize,[])';
    %     meanNeg = mean(decNeg');
    %     meanPos = mean(decPos');
    %
    %     decTest = reshape(decTest,groupSize,[])';
    %
    %     for n = 1:size(decTest,1)
    %         if min(meanPos)> max(meanNeg)
    %             if mean(decTest(n,:)') > max(meanNeg)
    %                 tstResults = [tstResults;1]
    %             else
    %                 tstResults = [tstResults; -1]
    %             end
    %         else
    %             if mean(decTest(n,:)') > min(meanPos)
    %                 tstResults = [tstResults;1]
    %             else
    %                 tstResults = [tstResults; -1]
    %             end
    %         end
    %     end
end
% tstResults = reshape(tstResults,2,[])';
%
% fprintf('\nFN= %f\n',sum(tstResults(:,1)==-1)/size(tstResults,1));
% fprintf('FP= %f\n',sum(tstResults(:,2)==1)/size(tstResults,1));

