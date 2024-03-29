clear all
clc
%load('result_digit9_balanced.mat')
load('C:\Users\User\Documents\GitHub\Group_Learning\digit_diff_positive\one_class_results_unbalaned.mat')
decNeg = reshape(decNeg,800,[]);
decPos = reshape(decPos,800,[]);

decValNeg = reshape(decValNeg,800,[]);
decValPos = reshape(decValPos,800,[]);

decValuesNegaTest = reshape(decValuesNegaTest,800,[]);
decValuesPosiTest = reshape(decValuesPosiTest,800,[]);

thr1 = quantile(mean(decNeg),1);
thr2 = quantile(std(decNeg),1);

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
plot([0 0],[0 0.25],'LineWidth',1,'Color',[0,0,0])
hold on
plot([1 1],[0 0.25],'--','LineWidth',1,'Color',[0,0,0])
hold on
plot([-1 -1],[0 0.25],'--','LineWidth',1,'Color',[0,0,0])
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
plot([0 0],[0 0.25],'LineWidth',1,'Color',[0,0,0])
hold on
plot([1 1],[0 0.25],'--','LineWidth',1,'Color',[0,0,0])
hold on
plot([-1 -1],[0 0.25],'--','LineWidth',1,'Color',[0,0,0])
hold off

figure(3)
thr1 = quantile(mean(decNeg),1);
thr2 = quantile(std(decNeg),1);
% patch([thr1 -0.65 -0.65 thr1], [thr2 thr2 0.26 0.26],'g') %shade positive prediction area
% hold on
scatter(mean(decNeg),std(decNeg),'r')
hold on
scatter(mean(decPos),std(decPos),'b')
% hold on
% plot([thr1 thr1],[0.14 0.26],'--','LineWidth',1,'Color',[0,0,0])
% hold on
% plot([-0.85 -0.65],[thr2 thr2],'--','LineWidth',1,'Color',[0,0,0])
xlabel('\mu')
ylabel('\sigma')
hold off


figure(4)
thr1 = quantile(mean(decNeg),1);
thr2 = quantile(std(decNeg),1);
% patch([thr1 -0.65 -0.65 thr1], [thr2 thr2 0.26 0.26],'g') %shade positive prediction area
% hold on
scatter(mean(decValuesNegaTest),std(decValuesNegaTest),'r')
hold on
scatter(mean(decValuesPosiTest),std(decValuesPosiTest),'b')
% hold on
% plot([thr1 thr1],[0.14 0.26],'--','LineWidth',1,'Color',[0,0,0])
% hold on
% plot([-0.85 -0.65],[thr2 thr2],'--','LineWidth',1,'Color',[0,0,0])
xlabel('\mu')
ylabel('\sigma')
hold off


SPCount = 0; 
for n = 1:size(decValuesNegaTest,2)
   if mean(decValuesNegaTest(:,n)) < thr1 && std(decValuesNegaTest(:,n)) < thr2
    SPCount = SPCount+1;
   end
end
SP = SPCount/size(decValuesNegaTest,2)


SSCount = 0; 
for n = 1:size(decValuesPosiTest,2)
   if mean(decValuesPosiTest(:,n)) > thr1 || std(decValuesPosiTest(:,n)) > thr2
    SSCount = SSCount+1;
   end
end
SS = SSCount/size(decValuesPosiTest,2)
