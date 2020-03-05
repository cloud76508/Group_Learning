clear all
clc
%load('C:\Users\User\Desktop\IJCNN\digit\Results\10Percent\Results.mat')
%load('C:\Users\User\Desktop\IJCNN\digit\Results_balanced.mat')
%load('C:\Users\User\Desktop\IJCNN\digit\Results\IJCNN_unbalanced\Results.mat')
%load('C:\Users\User\Desktop\IJCNN\digit\Results\IJCNN_balanced\Results.mat')

%load('C:\Users\User\Desktop\IJCNN\digit\Results\IJCNN_balanced\Results_feature.mat')
load('C:\Users\User\Desktop\IJCNN\digit\Results\IJCNN_unbalanced\Results_feature.mat')

%load('C:\Users\User\Desktop\IJCNN\digit\Results\1Percent\Results.mat')

decNeg = reshape(decNeg,800,[]);
decPos = reshape(decPos,800,[]);

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
%    tempThr = quantile(mean(decNeg),qunValue(m));
%    trainSS(n,1) = sum(mean(decPos)>tempThr)/size(decPos,2);
%    n = n+1;
% end
% [V,I] =  max(trainSS);
% qunValue(I)
% thr1 = quantile(mean(decNeg),qunValue(I));

%%Using validation data to decide threshold
trainSS = [];
n = 1;
qunValue = [1:-0.05:0];
for m = 1:length(qunValue)
   tempThr = quantile(mean(decValNeg),qunValue(m));
   trainSS(n,1) = sum(mean(decValPos)>tempThr)/size(decValPos,2);
   n = n+1;
end
[V,I] =  max(trainSS);
qunValue(I)
thr1 = quantile(mean(decValNeg),qunValue(I));


sprintf('SS = %d', sum(mean(decValuesPosiTest) > thr1)/size(decValuesPosiTest,2)*100)
sprintf('SP = %d', sum(mean(decValuesNegaTest) <= thr1)/size(decValuesNegaTest,2)*100)

figure(1)
msz = 8;
ColorRGB = [1 0 0];
LineW = 1;
for n =1:size(decNeg,2)
    [tempH,tempX]= hist(decNeg(:,n),-2:0.1:1.5);
    plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
    hold on
end

ColorRGB = [0 0 1];
LineW = 1.5;
for n =1:size(decPos,2)
    [tempH,tempX]= hist(decPos(:,n),-2:0.1:1.5);
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
scatter(mean(decNeg),zeros(size(mean(decNeg),2),1),'r')
hold on
scatter(mean(decPos),zeros(size(mean(decPos),2),1),'b')
hold on
plot([thr1 thr1],[-0.5 0.5],'--','LineWidth',1,'Color',[0,0,0])
xlabel('\mu')
set(gca,'ytick',[])
box on
hold off


figure(4)
scatter(mean(decValuesNegaTest),zeros(size(mean(decValuesNegaTest),2),1),'r')
hold on
scatter(mean(decValuesPosiTest),zeros(size(mean(decValuesPosiTest),2),1),'b')
hold on
plot([thr1 thr1],[-0.5 0.5],'--','LineWidth',1,'Color',[0,0,0])
xlabel('\mu')
set(gca,'ytick',[])
box on
hold off

