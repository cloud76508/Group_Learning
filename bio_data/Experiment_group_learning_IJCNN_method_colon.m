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


groupSize = 10; 

groupData = [];
for n =1:size(rawData,1)
    groupData = [groupData; reshape(rawData(n,:), [],groupSize)'];
end

groupLabel = [ones(sum(label == 1)*groupSize,1);-ones(sum(label == -1)*groupSize,1)];

rawData = groupData;
label = groupLabel;

crossValAccuracy = [];

tstResults = [];
weight = 1;
%weight = 0.1875;


decPos = [];
decNeg = [];
decTest = [];
for n = 1:12
    positiveData = rawData(label==1,:);
    negativeData = rawData(label==-1,:);
    positiveLabel = label(label==1,:);
    negativeLabel = label(label==-1,:);
    
    test.X = [positiveData((n-1)*groupSize+1:n*groupSize,:);negativeData((n-1)*groupSize+1:n*groupSize,:)];
    test.y = [positiveLabel((n-1)*groupSize+1:n*groupSize,:);negativeLabel((n-1)*groupSize+1:n*groupSize,:)];
    
    trainPos = positiveData;
    trainPos((n-1)*groupSize+1:n*groupSize,:) =[];
    trainPosLab = ones(size(trainPos,1),1);
    trainNeg = negativeData;
    trainNeg((n-1)*groupSize+1:n*groupSize,:) =[];
    trainNegLab = -ones(size(trainNeg,1),1);  
    
    trainSet.X = [trainPos;trainNeg];
    trainSet.y = [trainPosLab;trainNegLab];

    setFold = sum(trainSet.y == 1)/groupSize;
    
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
             %[pred, crossValAccuracy(idx,fold), dec] = do_binary_predict(val.y, sparse(val.X), mdl);
        end
    end
    
    % -------------------------------------------------------------
    % find the optimal C
    % -------------------------------------------------------------
    [validAcc, opt_C_idx] = max(mean(crossValAccuracy, 2));
    opt_C = C(opt_C_idx);
    
    % -------------------------------------------------------------
    % estimate the model using optiomal C
    % -------------------------------------------------------------
    option_liblinear = ['-w+1 ', num2str(weight), ' -w-1 1 -c ', num2str(opt_C), ' -s 1 -q'];
    model = train(trainSet.y, sparse(trainSet.X), option_liblinear);
    
    % outputs for training data
    [~, ~, decPos(:,n)] = predict(ones(size(trainPos,1),1), sparse(trainPos), model);
    [~, ~, decNeg(:,n)] = predict(-ones(size(trainNeg,1),1), sparse(trainNeg), model);
    
    [~, ~, decTest(:,n)] = predict(test.y, sparse(test.X), model);
  
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

