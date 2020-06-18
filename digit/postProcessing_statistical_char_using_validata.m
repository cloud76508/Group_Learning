clear all
clc
%load('C:\Users\User\Desktop\IJCNN\digit\Results\10Percent\Results.mat')
%load('C:\Users\User\Desktop\IJCNN\digit\Results_balanced.mat')
%load('C:\Users\User\Desktop\IJCNN\digit\Results\IJCNN_unbalanced\Results.mat')
%load('C:\Users\User\Desktop\IJCNN\digit\Results\IJCNN_balanced\Results.mat')

%load('C:\Users\User\Desktop\IJCNN\digit\Results\IJCNN_balanced\Results_feature.mat')
%load('C:\Users\User\Desktop\IJCNN\digit\Results\IJCNN_unbalanced\Results_feature.mat')

%load('C:\Users\User\Documents\GitHub\Group_Learning\digit\Results\Results_1P.mat')
%load('C:\Users\User\Documents\GitHub\Group_Learning\digit\Results\Results_2point5P.mat')
%load('C:\Users\User\Documents\GitHub\Group_Learning\digit\Results\Results_25P.mat')
load('C:\Users\User\Documents\GitHub\Group_Learning\digit\Results\Results_10P.mat')
%load('C:\Users\User\Documents\GitHub\Group_Learning\digit\Results\Results_partial_50.mat')

decValNeg = reshape(decValNeg,800,[]);
decValPos = reshape(decValPos,800,[]);

decValNeg = reshape(decValNeg,800,[]);
decValPos = reshape(decValPos,800,[]);

%decValuesNegaTest = reshape(decValuesNegaTest,800,[]);
%decValuesPosiTest = reshape(decValuesPosiTest,800,[]);

decValuesNegaTest = decValuesNegaTest';
decValuesPosiTest = decValuesPosiTest';

%%Using training data to decide threshold
% trainSS = [];
% n = 1;
% qunValue = [1:-0.05:0];
% for m = 1:length(qunValue)
%    tempThr = quantile(mean(decValNeg),qunValue(m));
%    trainSS(n,1) = sum(mean(decValPos)>tempThr)/size(decValPos,2);
%    n = n+1;
% end
% [V,I] =  max(trainSS);
% qunValue(I)
% thr1 = quantile(mean(decValNeg),qunValue(I));

% %%Using validation data to decide threshold
% trainSS = [];
% n = 1;
% qunValue = [1:-0.05:0];
% for m = 1:length(qunValue)
%    tempThr = quantile(mean(decValNeg),qunValue(m));
%    trainSS(n,1) = sum(mean(decValPos)>tempThr)/size(decValPos,2);
%    n = n+1;
% end
% [V,I] =  max(trainSS);
% qunValue(I)
% thr1 = quantile(mean(decValNeg),qunValue(I));

% %====================================================================================================
% %%Using validation data to decide threshold (mean)
% %====================================================================================================
% 
% trainSS = [];
% n = 1;
% qunValue = [1:-0.05:0];
% for m = 1:length(qunValue)
%    tempThr = quantile(mean(decValNeg),qunValue(m));
%    trainSS(n,1) = sum(mean(decValPos)>tempThr)/size(decValPos,2);
%    n = n+1;
% end
% [V,I] =  max(trainSS);
% qunValue(I)
% thr1 = quantile(mean(decValNeg),qunValue(I));
% 
% sprintf('SS = %d', sum(mean(decValuesPosiTest) > thr1)/size(decValuesPosiTest,2)*100)
% sprintf('SP = %d', sum(mean(decValuesNegaTest) <= thr1)/size(decValuesNegaTest,2)*100)
% 
% figure(1)
% msz = 8;
% ColorRGB = [1 0 0];
% LineW = 1;
% for n =1:size(decValNeg,2)
%     [tempH,tempX]= hist(decValNeg(:,n),-2:0.1:1.5);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% 
% ColorRGB = [0 0 1];
% LineW = 1.5;
% for n =1:size(decValPos,2)
%     [tempH,tempX]= hist(decValPos(:,n),-2:0.1:1.5);
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
% figure(2)
% msz = 8;
% ColorRGB = [1 0 0];
% LineW = 1;
% for n =1:size(decValuesNegaTest,2)
%     [tempH,tempX]= hist(decValuesNegaTest(:,n),-2:0.1:1.5);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% 
% ColorRGB = [0 0 1];
% LineW = 1.5;
% for n =1:size(decValuesPosiTest,2)
%     [tempH,tempX]= hist(decValuesPosiTest(:,n),-2:0.1:1.5);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% yLimit = ylim;
% plot([0 0],[yLimit(1) 0.35],'LineWidth',1,'Color',[0,0,0])
% hold on
% plot([1 1],[yLimit(1) 0.35],'--','LineWidth',1,'Color',[0,0,0])
% hold on
% plot([-1 -1],[yLimit(1) 0.35],'--','LineWidth',1,'Color',[0,0,0])
% hold off
% 
% 
% figure(3)
% scatter(mean(decValNeg),zeros(size(mean(decValNeg),2),1),'r')
% hold on
% scatter(mean(decValPos),zeros(size(mean(decValPos),2),1),'b')
% hold on
% plot([thr1 thr1],[-0.5 0.5],'--','LineWidth',1,'Color',[0,0,0])
% xlabel('\mu')
% set(gca,'ytick',[])
% box on
% hold off
% 
% 
% figure(4)
% scatter(mean(decValuesNegaTest),zeros(size(mean(decValuesNegaTest),2),1),'r')
% hold on
% scatter(mean(decValuesPosiTest),zeros(size(mean(decValuesPosiTest),2),1),'b')
% hold on
% plot([thr1 thr1],[-0.5 0.5],'--','LineWidth',1,'Color',[0,0,0])
% xlabel('\mu')
% set(gca,'ytick',[])
% box on
% hold off
% %====================================================================================================


% %====================================================================================================
% %%Using training data to decide threshold (median)
% %====================================================================================================
% 
% trainSS = [];
% n = 1;
% qunValue = [1:-0.05:0];
% for m = 1:length(qunValue)
%    tempThr = quantile(median(decValNeg),qunValue(m));
%    trainSS(n,1) = sum(median(decValPos)>tempThr)/size(decValPos,2);
%    n = n+1;
% end
% [V,I] =  max(trainSS);
% qunValue(I)
% thr1 = quantile(median(decValNeg),qunValue(I));
% 
% sprintf('SS = %d', sum(median(decValuesPosiTest) > thr1)/size(decValuesPosiTest,2)*100)
% sprintf('SP = %d', sum(median(decValuesNegaTest) <= thr1)/size(decValuesNegaTest,2)*100)
% 
% figure(1)
% msz = 8;
% ColorRGB = [1 0 0];
% LineW = 1;
% for n =1:size(decValNeg,2)
%     [tempH,tempX]= hist(decValNeg(:,n),-2:0.1:1.5);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% 
% ColorRGB = [0 0 1];
% LineW = 1.5;
% for n =1:size(decValPos,2)
%     [tempH,tempX]= hist(decValPos(:,n),-2:0.1:1.5);
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
% figure(2)
% msz = 8;
% ColorRGB = [1 0 0];
% LineW = 1;
% for n =1:size(decValuesNegaTest,2)
%     [tempH,tempX]= hist(decValuesNegaTest(:,n),-2:0.1:1.5);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% 
% ColorRGB = [0 0 1];
% LineW = 1.5;
% for n =1:size(decValuesPosiTest,2)
%     [tempH,tempX]= hist(decValuesPosiTest(:,n),-2:0.1:1.5);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% yLimit = ylim;
% plot([0 0],[yLimit(1) 0.35],'LineWidth',1,'Color',[0,0,0])
% hold on
% plot([1 1],[yLimit(1) 0.35],'--','LineWidth',1,'Color',[0,0,0])
% hold on
% plot([-1 -1],[yLimit(1) 0.35],'--','LineWidth',1,'Color',[0,0,0])
% hold off
% 
% 
% figure(3)
% scatter(median(decValNeg),zeros(size(median(decValNeg),2),1),'r')
% hold on
% scatter(median(decValPos),zeros(size(median(decValPos),2),1),'b')
% hold on
% plot([thr1 thr1],[-0.5 0.5],'--','LineWidth',1,'Color',[0,0,0])
% xlabel('median')
% set(gca,'ytick',[])
% box on
% hold off
% 
% 
% figure(4)
% scatter(median(decValuesNegaTest),zeros(size(median(decValuesNegaTest),2),1),'r')
% hold on
% scatter(median(decValuesPosiTest),zeros(size(median(decValuesPosiTest),2),1),'b')
% hold on
% plot([thr1 thr1],[-0.5 0.5],'--','LineWidth',1,'Color',[0,0,0])
% xlabel('median')
% set(gca,'ytick',[])
% box on
% hold off
% %====================================================================================================

% %====================================================================================================
% %%Using validation data to decide threshold (std)
% %====================================================================================================
% 
% trainSS = [];
% n = 1;
% qunValue = [1:-0.05:0];
% for m = 1:length(qunValue)
%    tempThr = quantile(std(decValNeg),qunValue(m));
%    trainSS(n,1) = sum(std(decValPos)>tempThr)/size(decValPos,2);
%    n = n+1;
% end
% [V,I] =  max(trainSS);
% qunValue(I)
% thr1 = quantile(std(decValNeg),qunValue(I));
% 
% sprintf('SS = %d', sum(std(decValuesPosiTest) > thr1)/size(decValuesPosiTest,2)*100)
% sprintf('SP = %d', sum(std(decValuesNegaTest) <= thr1)/size(decValuesNegaTest,2)*100)
% 
% figure(1)
% msz = 8;
% ColorRGB = [1 0 0];
% LineW = 1;
% for n =1:size(decValNeg,2)
%     [tempH,tempX]= hist(decValNeg(:,n),-2:0.1:1.5);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% 
% ColorRGB = [0 0 1];
% LineW = 1.5;
% for n =1:size(decValPos,2)
%     [tempH,tempX]= hist(decValPos(:,n),-2:0.1:1.5);
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
% figure(2)
% msz = 8;
% ColorRGB = [1 0 0];
% LineW = 1;
% for n =1:size(decValuesNegaTest,2)
%     [tempH,tempX]= hist(decValuesNegaTest(:,n),-2:0.1:1.5);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% 
% ColorRGB = [0 0 1];
% LineW = 1.5;
% for n =1:size(decValuesPosiTest,2)
%     [tempH,tempX]= hist(decValuesPosiTest(:,n),-2:0.1:1.5);
%     plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
%     hold on
% end
% yLimit = ylim;
% plot([0 0],[yLimit(1) 0.35],'LineWidth',1,'Color',[0,0,0])
% hold on
% plot([1 1],[yLimit(1) 0.35],'--','LineWidth',1,'Color',[0,0,0])
% hold on
% plot([-1 -1],[yLimit(1) 0.35],'--','LineWidth',1,'Color',[0,0,0])
% hold off
% 
% 
% figure(3)
% scatter(std(decValNeg),zeros(size(std(decValNeg),2),1),'r')
% hold on
% scatter(std(decValPos),zeros(size(std(decValPos),2),1),'b')
% hold on
% plot([thr1 thr1],[-0.5 0.5],'--','LineWidth',1,'Color',[0,0,0])
% xlabel('std')
% set(gca,'ytick',[])
% box on
% hold off
% 
% 
% figure(4)
% scatter(std(decValuesNegaTest),zeros(size(std(decValuesNegaTest),2),1),'r')
% hold on
% scatter(std(decValuesPosiTest),zeros(size(std(decValuesPosiTest),2),1),'b')
% hold on
% plot([thr1 thr1],[-0.5 0.5],'--','LineWidth',1,'Color',[0,0,0])
% xlabel('std')
% set(gca,'ytick',[])
% box on
% hold off
% %====================================================================================================


%====================================================================================================
%%Using validation data to decide threshold (quantile)
%====================================================================================================

assigned_Q = 0.75;

trainSS = [];
n = 1;
qunValue = [1:-0.05:0];
for m = 1:length(qunValue)
   tempThr = quantile(std(decValNeg),qunValue(m));
   trainSS(n,1) = sum(std(decValPos)>tempThr)/size(decValPos,2);
   n = n+1;
end
[V,I] =  max(trainSS);
qunValue(I)
thr1 = quantile(quantile(decValNeg,assigned_Q),qunValue(I));

sprintf('SS = %d', sum(quantile(decValuesPosiTest,assigned_Q) > thr1)/size(decValuesPosiTest,2)*100)
sprintf('SP = %d', sum(quantile(decValuesNegaTest,assigned_Q) <= thr1)/size(decValuesNegaTest,2)*100)

figure(1)
msz = 8;
ColorRGB = [1 0 0];
LineW = 1;
for n =1:size(decValNeg,2)
    [tempH,tempX]= hist(decValNeg(:,n),-2:0.1:1.5);
    plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
    hold on
end

ColorRGB = [0 0 1];
LineW = 1.5;
for n =1:size(decValPos,2)
    [tempH,tempX]= hist(decValPos(:,n),-2:0.1:1.5);
    plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
    hold on
end
yLimit = ylim;
plot([0 0],[yLimit(1) yLimit(2)],'LineWidth',1,'Color',[0,0,0])
hold on
plot([1 1],[yLimit(1) yLimit(2)],'--','LineWidth',1,'Color',[0,0,0])
hold on
plot([-1 -1],[yLimit(1) yLimit(2)],'--','LineWidth',1,'Color',[0,0,0])
hold off

figure(2)
msz = 8;
ColorRGB = [1 0 0];
LineW = 1;
for n =1:size(decValuesNegaTest,2)
    [tempH,tempX]= hist(decValuesNegaTest(:,n),-2:0.1:1.5);
    plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
    hold on
end

ColorRGB = [0 0 1];
LineW = 1.5;
for n =1:size(decValuesPosiTest,2)
    [tempH,tempX]= hist(decValuesPosiTest(:,n),-2:0.1:1.5);
    plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
    hold on
end
yLimit = ylim;
plot([0 0],[yLimit(1) 0.35],'LineWidth',1,'Color',[0,0,0])
hold on
plot([1 1],[yLimit(1) 0.35],'--','LineWidth',1,'Color',[0,0,0])
hold on
plot([-1 -1],[yLimit(1) 0.35],'--','LineWidth',1,'Color',[0,0,0])
hold off


figure(3)
scatter(quantile(decValNeg,assigned_Q),zeros(size(std(decValNeg),2),1),'r')
hold on
scatter(quantile(decValPos,assigned_Q),zeros(size(std(decValPos),2),1),'b')
hold on
plot([thr1 thr1],[-0.5 0.5],'--','LineWidth',1,'Color',[0,0,0])
xlabel('25% qunatile')
set(gca,'ytick',[])
box on
hold off


figure(4)
scatter(quantile(decValuesNegaTest,assigned_Q),zeros(size(std(decValuesNegaTest),2),1),'r')
hold on
scatter(quantile(decValuesPosiTest,assigned_Q),zeros(size(std(decValuesPosiTest),2),1),'b')
hold on
plot([thr1 thr1],[-0.5 0.5],'--','LineWidth',1,'Color',[0,0,0])
xlabel('25% quantile')
set(gca,'ytick',[])
box on
hold off
%====================================================================================================