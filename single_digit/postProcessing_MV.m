 clear all
 clc
% %load('C:\Users\User\Desktop\IJCNN\digit\Results\IJCNN_balanced\Results_feature.mat')
% load('C:\Users\User\Documents\GitHub\Group_Learning\digit_small_digit_matrix\Results\Group_5.mat')
% %load('C:\Users\User\Documents\GitHub\Group_Learning\digit_small_digit_matrix\Results\Group_5_75p.mat')
% %load('C:\Users\User\Documents\GitHub\Group_Learning\digit_small_digit_matrix\Results\test.mat')
%window_size_list = [10,14,15,20,23,24,25,26,27,28];
load('C:\Users\ASUS\Documents\GitHub\Group_Learning\single_digit\Results\SVM_GL_W25_v1.mat')

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
    end
end

FP = 0;
for n = 1:size(decValuesIntTest,2)
    positiveVote = sum(decValuesIntTest(:,n) > 0);
    negativeVote = sum(decValuesIntTest(:,n) < 0);    
    if positiveVote > negativeVote
       FP = FP +1;
    end
end

%mtehod 2 Majority vote
FN_train = 0;
for n = 1:size(decPos,2)
    positiveVote = sum(decPos(:,n) > 0);
    negativeVote = sum(decPos(:,n) < 0);    
    if negativeVote > positiveVote
       FN_train = FN_train +1;
    end
end

FP_train = 0;
for n = 1:size(decNeg,2)
    positiveVote = sum(decNeg(:,n) > 0);
    negativeVote = sum(decNeg(:,n) < 0);    
    if positiveVote > negativeVote
       FP_train = FP_train +1;
    end
end

fprintf('Train_error = %.3f\n', (FN_train+FP_train)/(size(decPos,2)+size(decPos,2)))
fprintf('Test_error = %.3f\n', (FP+FN)/(size(decValuesPreTest,2)+size(decValuesIntTest,2)))

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
