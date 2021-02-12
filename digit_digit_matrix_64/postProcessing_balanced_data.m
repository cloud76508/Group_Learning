 clear all
 clc
%load('C:\Users\User\Desktop\IJCNN\digit\Results\IJCNN_balanced\Results_feature.mat')
% load('C:\Users\User\Documents\GitHub\Group_Learning\digit_small_digit_matrix\Results\A.mat')
%load('C:\Users\User\Documents\GitHub\Group_Learning\digit_small_digit_matrix\Results\Group_R_W10_1.mat')
load('C:\Users\ASUS\Documents\GitHub\Group_Learning\digit_digit_matrix_64\Results\SVM_GL_W112.mat')
number_windows = size(decValuesPosiTest,2);

method = 1;

decNeg = reshape(decNeg,number_windows,[]);
decPos = reshape(decPos,number_windows,[]);
decValuesIntTest = decValuesNegaTest';
decValuesPreTest = decValuesPosiTest';

decValNeg = reshape(decValNeg,number_windows,[]);
decValPos = reshape(decValPos,number_windows,[]);

decValuesNegaTest = decValuesNegaTest';
decValuesPosiTest = decValuesPosiTest';

% %Using training data to decide threshold
% trainSS = [];
% n = 1;
% qunValue = [1:-0.05:0];
% for m = 1:length(qunValue)
%    tempThr = quantile(mean(decNeg),qunValue(m));
%    trainSS(n,1) = sum(mean(decPos)>tempThr)/size(decPos,2);
%    n = n+1;
% end
% [V,I] =  max(trainSS);
% qunValue(I)
% thr1 = quantile(mean(decNeg),qunValue(I));

if method == 1 %mean   
    %Using validation data to decide threshold
    trainSS = [];
    n = 1;
    m = 1;
    qunNeg = [1:-0.05:0];
    qunPos = [0:0.05:1];
    valSS = [];
    valSP = [];
    for i = 1:length(qunNeg)
        for j = 1:length(qunPos)
            if quantile(mean(decValNeg),qunNeg(i)) < quantile(mean(decValPos),qunPos(j))
                tempThr(i,j) = (quantile(mean(decValNeg),qunNeg(i)) + quantile(mean(decValPos),qunPos(j)))/2 ;
                valSS(i,j) = sum(mean(decValPos)>tempThr(i,j))/size(decValPos,2);
                valSP(i,j) = sum(mean(decValNeg)<tempThr(i,j))/size(decValNeg,2);
            end
        end
    end
    valACC = valSS+valSP;
    
    [~,tempIndex] =  max(valACC);
    [~,indexM] =  max(max(valACC));
    indexN = tempIndex(indexM);
   
    thr1 = (quantile(mean(decValNeg),qunNeg(indexN)) + quantile(mean(decValPos),qunPos(indexM)))/2;
    
    
    sprintf('SS_training = %d', sum(mean(decPos) > thr1)/size(decPos,2)*100)
    sprintf('SP_training = %d', sum(mean(decNeg) <= thr1)/size(decNeg,2)*100)
    
    sprintf('SS = %d', sum(mean(decValuesPosiTest) > thr1)/size(decValuesPosiTest,2)*100)
    sprintf('SP = %d', sum(mean(decValuesNegaTest) <= thr1)/size(decValuesNegaTest,2)*100)
end


% figure(1)
% msz = 8;
% ColorRGB = [1 0 0];
% LineW = 1;
% for n =1:size(decNeg,2)
%     [tempH,tempX]= hist(decNeg(:,n),-4:0.1:4);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% 
% ColorRGB = [0 0 1];
% LineW = 1.5;
% for n =1:size(decPos,2)
%     [tempH,tempX]= hist(decPos(:,n),-4:0.1:4);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% yLimit = ylim;
% plot([0 0],[yLimit(1) yLimit(2)+0.1],'LineWidth',1,'Color',[0,0,0])
% hold on
% plot([1 1],[yLimit(1) yLimit(2)+0.1],'--','LineWidth',1,'Color',[0,0,0])
% hold on
% plot([-1 -1],[yLimit(1) yLimit(2)+0.1],'--','LineWidth',1,'Color',[0,0,0])
% %ylim([0 0.5])
% %xlim([-1.5 1.5])
% hold off
% 
% figure(2)
% msz = 8;
% ColorRGB = [1 0 0];
% LineW = 1;
% for n =1:size(decNeg,2)
%     [tempH,tempX]= hist(decValNeg(:,n),-4:0.1:4);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% 
% ColorRGB = [0 0 1];
% LineW = 1.5;
% for n =1:size(decPos,2)
%     [tempH,tempX]= hist(decValPos(:,n),-4:0.1:4);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% yLimit = ylim;
% plot([0 0],[yLimit(1) yLimit(2)+0.1],'LineWidth',1,'Color',[0,0,0])
% hold on
% plot([1 1],[yLimit(1) yLimit(2)+0.1],'--','LineWidth',1,'Color',[0,0,0])
% hold on
% plot([-1 -1],[yLimit(1) yLimit(2)+0.1],'--','LineWidth',1,'Color',[0,0,0])
% %ylim([0 0.5])
% %xlim([-1.5 1.5])
% hold off
% 
% 
% 
% figure(3)
% msz = 8;
% ColorRGB = [1 0 0];
% LineW = 1;
% for n =1:size(decValuesNegaTest,2)
%     [tempH,tempX]= hist(decValuesNegaTest(:,n),-4:0.1:4);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% 
% ColorRGB = [0 0 1];
% LineW = 1.5;
% for n =1:size(decValuesPosiTest,2)
%     [tempH,tempX]= hist(decValuesPosiTest(:,n),-4:0.1:4);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% yLimit = ylim;
% plot([0 0],[yLimit(1) yLimit(2)+0.1],'LineWidth',1,'Color',[0,0,0])
% hold on
% plot([1 1],[yLimit(1) yLimit(2)+0.1],'--','LineWidth',1,'Color',[0,0,0])
% hold on
% plot([-1 -1],[yLimit(1) yLimit(2)+0.1],'--','LineWidth',1,'Color',[0,0,0])
% %ylim([0 0.5])
% %xlim([-1.5 1.5])
% hold off
% 
% 
% figure(4)
% scatter(mean(decNeg),zeros(size(mean(decNeg),2),1),'r')
% hold on
% scatter(mean(decPos),zeros(size(mean(decPos),2),1),'b')
% hold on
% plot([thr1 thr1],[-0.5 0.5],'--','LineWidth',1,'Color',[0,0,0])
% xlabel('\mu')
% set(gca,'ytick',[])
% box on
% xlim([-3 2])
% hold off
% 
% figure(5)
% scatter(mean(decValNeg),zeros(size(mean(decValNeg),2),1),'r')
% hold on
% scatter(mean(decValPos),zeros(size(mean(decValPos),2),1),'b')
% hold on
% plot([thr1 thr1],[-0.5 0.5],'--','LineWidth',1,'Color',[0,0,0])
% xlabel('\mu')
% set(gca,'ytick',[])
% box on
% xlim([-3 2])
% hold off
% 
% 
% figure(6)
% scatter(mean(decValuesNegaTest),zeros(size(mean(decValuesNegaTest),2),1),'r')
% hold on
% scatter(mean(decValuesPosiTest),zeros(size(mean(decValuesPosiTest),2),1),'b')
% hold on
% plot([thr1 thr1],[-0.5 0.5],'--','LineWidth',1,'Color',[0,0,0])
% xlabel('\mu')
% set(gca,'ytick',[])
% box on
% xlim([-3 2])
% hold off
