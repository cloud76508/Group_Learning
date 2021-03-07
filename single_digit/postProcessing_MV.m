% clear all
% clc
% %load('C:\Users\User\Desktop\IJCNN\digit\Results\IJCNN_balanced\Results_feature.mat')
% load('C:\Users\User\Documents\GitHub\Group_Learning\digit_small_digit_matrix\Results\Group_5.mat')
% %load('C:\Users\User\Documents\GitHub\Group_Learning\digit_small_digit_matrix\Results\Group_5_75p.mat')
% %load('C:\Users\User\Documents\GitHub\Group_Learning\digit_small_digit_matrix\Results\test.mat')
%window_size_list = [10,14,15,20,23,24,25,26,27,28];
load('C:\Users\ASUS\Documents\GitHub\Group_Learning\single_digit\Results\SVM_GL_W10.mat')

decNeg = reshape(decNeg,5,[]);
decPos = reshape(decPos,5,[]);
decValuesIntTest = decValuesNegaTest';
decValuesPreTest = decValuesPosiTest';

% %mtehod 1
% thr1 = 1;
% TP = 0;
% for n = 1:size(decValuesPreTest,2)
%     if sum(decValuesPreTest(:,n) > 0) >= thr1
%        TP = TP +1;
%     end
% end
% 
% TN = 0;
% for n = 1:size(decValuesIntTest,2)
%     if sum(decValuesIntTest(:,n)>0) < thr1
%        TN = TN +1;
%     end
% end

%mtehod 2 Majority vote
TP = 0;
for n = 1:size(decValuesPreTest,2)
    positiveVote = sum(decValuesPreTest(:,n) > 0);
    negativeVote = sum(decValuesPreTest(:,n) < 0);    
    if positiveVote > negativeVote
       TP = TP +1;
    end
end

TN = 0;
for n = 1:size(decValuesIntTest,2)
    positiveVote = sum(decValuesIntTest(:,n) > 0);
    negativeVote = sum(decValuesIntTest(:,n) < 0);    
    if negativeVote > positiveVote
       TN = TN +1;
    end
end

fprintf('FN = %.3f\n', 1-TP/size(decValuesPreTest,2))
fprintf('FP = %.3f\n', 1-TN/size(decValuesIntTest,2))
fprintf('Test_Acc = %.3f\n', (TP+TN)/(size(decValuesPreTest,2)+size(decValuesIntTest,2)))

%mtehod 2 Majority vote
TP_train = 0;
for n = 1:size(decPos,2)
    positiveVote = sum(decPos(:,n) > 0);
    negativeVote = sum(decPos(:,n) < 0);    
    if positiveVote > negativeVote
       TP_train = TP_train +1;
    end
end

TN_train = 0;
for n = 1:size(decNeg,2)
    positiveVote = sum(decNeg(:,n) > 0);
    negativeVote = sum(decNeg(:,n) < 0);    
    if negativeVote > positiveVote
       TN_train = TN_train +1;
    end
end

fprintf('FN_train = %.3f\n', 1-TP_train/size(decPos,2))
fprintf('FP_train = %.3f\n', 1-TN_train/size(decPos,2))
fprintf('Train_Acc = %.3f\n', (TP_train+TN_train)/(size(decPos,2)+size(decPos,2)))


% figure(1)
% msz = 8;
% ColorRGB = [1 0 0];
% LineW = 1;
% for n =1:size(decNeg,2)
%     [tempH,tempX]= hist(decNeg(:,n),-2:0.1:1.5);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% 
% ColorRGB = [0 0 1];
% LineW = 1.5;
% for n =1:size(decPos,2)
%     [tempH,tempX]= hist(decPos(:,n),-2:0.1:1.5);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% yLimit = ylim;
% plot([0 0],[yLimit(1) yLimit(2)],'LineWidth',1,'Color',[0,0,0])
% hold on
% plot([1 1],[yLimit(1) yLimit(2)],'--','LineWidth',1,'Color',[0,0,0])
% hold on
% plot([-1 -1],[yLimit(1) yLimit(2)],'--','LineWidth',1,'Color',[0,0,0])
% hold off
% 
% 
% figure(2)
% msz = 8;
% ColorRGB = [1 0 0];
% LineW = 1;
% for n =1:size(decValuesIntTest,2)
%     [tempH,tempX]= hist(decValuesIntTest(:,n),-2:0.1:1.5);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% 
% ColorRGB = [0 0 1];
% LineW = 1.5;
% for n =1:size(decValuesPreTest,2)
%     [tempH,tempX]= hist(decValuesPreTest(:,n),-2:0.1:1.5);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% yLimit = ylim;
% plot([0 0],[yLimit(1) yLimit(2)],'LineWidth',1,'Color',[0,0,0])
% hold on
% plot([1 1],[yLimit(1) yLimit(2)],'--','LineWidth',1,'Color',[0,0,0])
% hold on
% plot([-1 -1],[yLimit(1) yLimit(2)],'--','LineWidth',1,'Color',[0,0,0])
% hold off
% 
% figure(3)
% %thr1 = quantile(mean(decNeg),1);
% thr2 = quantile(std(decNeg),1);
% patch([thr1 -0.65 -0.65 thr1], [thr2 thr2 0.26 0.26],'g') %shade positive prediction area
% hold on
% scatter(mean(decNeg),std(decNeg),'r')
% hold on
% scatter(mean(decPos),std(decPos),'b')
% hold on
% plot([thr1 thr1],[0.14 0.26],'--','LineWidth',1,'Color',[0,0,0])
% hold on
% plot([-0.85 -0.65],[thr2 thr2],'--','LineWidth',1,'Color',[0,0,0])
% xlabel('\mu')
% ylabel('\sigma')
% hold off
% 
% 
% figure(4)
% %thr1 = quantile(mean(decNeg),1);
% thr2 = quantile(std(decNeg),1);
% patch([thr1 -0.65 -0.65 thr1], [thr2 thr2 0.26 0.26],'g') %shade positive prediction area
% hold on
% scatter(mean(decValuesIntTest),std(decValuesIntTest),'r')
% hold on
% scatter(mean(decValuesPreTest),std(decValuesPreTest),'b')
% hold on
% plot([thr1 thr1],[0.14 0.26],'--','LineWidth',1,'Color',[0,0,0])
% hold on
% plot([-0.85 -0.65],[thr2 thr2],'--','LineWidth',1,'Color',[0,0,0])
% xlabel('\mu')
% ylabel('\sigma')
% hold off
