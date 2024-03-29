% clear all
% clc
% load('Results.mat')
decNeg = reshape(decNeg,800,[]);
decPos = reshape(decPos,800,[]);
decValuesIntTest = reshape(decValuesIntTest,800,[]);
decValuesPreTest = reshape(decValuesPreTest,800,[]);

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
for n =1:size(decValuesIntTest,2)
    [tempH,tempX]= hist(decValuesIntTest(:,n),-2:0.1:1.5);
    plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
    hold on
end

ColorRGB = [0 0 1];
LineW = 1.5;
for n =1:size(decValuesPreTest,2)
    [tempH,tempX]= hist(decValuesPreTest(:,n),-2:0.1:1.5);
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
patch([thr1 -0.65 -0.65 thr1], [thr2 thr2 0.26 0.26],'g') %shade positive prediction area
hold on
scatter(mean(decNeg),std(decNeg),'r')
hold on
scatter(mean(decPos),std(decPos),'b')
hold on
plot([thr1 thr1],[0.14 0.26],'--','LineWidth',1,'Color',[0,0,0])
hold on
plot([-0.85 -0.65],[thr2 thr2],'--','LineWidth',1,'Color',[0,0,0])
xlabel('\mu')
ylabel('\sigma')
hold off


figure(4)
thr1 = quantile(mean(decNeg),1);
thr2 = quantile(std(decNeg),1);
patch([thr1 -0.65 -0.65 thr1], [thr2 thr2 0.26 0.26],'g') %shade positive prediction area
hold on
scatter(mean(decValuesIntTest),std(decValuesIntTest),'r')
hold on
scatter(mean(decValuesPreTest),std(decValuesPreTest),'b')
hold on
plot([thr1 thr1],[0.14 0.26],'--','LineWidth',1,'Color',[0,0,0])
hold on
plot([-0.85 -0.65],[thr2 thr2],'--','LineWidth',1,'Color',[0,0,0])
xlabel('\mu')
ylabel('\sigma')
hold off
