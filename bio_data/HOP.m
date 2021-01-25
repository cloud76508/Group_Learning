clear all
clc
load('Results_groupsize_5.mat')

msz = 8;
LineW = 1;
ColorRGB = [0 0 1];
figure(1);
for n = 1:size(decPos,1)
    [tempH,tempX]= hist(decPos(n,:));
    plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
    hold on
end

ColorRGB = [1 0 0];
for n = 1:size(decNeg,1)
    [tempH,tempX]= hist(decNeg(n,:));
    plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)
    hold on
end
hold off

figure(1);
[tempH,tempX]= hist(decNeg(n,:));
plot(tempX,tempH/sum(tempH),'LineWidth',LineW,'Color',ColorRGB,'MarkerSize',msz)


