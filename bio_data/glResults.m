clear all
clc
load Results_groupsize_25

tstResults = [];
for exp = 1:12
    
    negResults = reshape(decNeg(:,exp),groupSize,[])';
    posResults = reshape(decPos(:,exp),groupSize,[])';
    meanNeg = mean(negResults');
    meanPos = mean(posResults');
    
    testResults = reshape(decTest(:,exp),groupSize,[])';
    
    
    for n = 1:size(testResults,1)
        if min(meanPos)> max(meanNeg)
            if mean(testResults(n,:)') > max(meanNeg)
                tstResults = [tstResults;1]
            else
                tstResults = [tstResults; -1]
            end
        else
            if mean(testResults(n,:)') > min(meanPos)
                tstResults = [tstResults;1]
            else
                tstResults = [tstResults; -1]
            end
        end
    end
    
    figure(exp)
    scatter(meanNeg,ones(length(meanNeg),1))
    hold on
    scatter(meanPos,ones(length(meanPos),1))
    hold on
    scatter(mean(testResults'),[1,1],'x')
    hold off
    
    
end

tstResults = reshape(tstResults,2,[])';

fprintf('\nTP= %f\n',sum(tstResults(:,1)==1)/size(tstResults,1));
fprintf('TN= %f\n',sum(tstResults(:,2)==-1)/size(tstResults,1));