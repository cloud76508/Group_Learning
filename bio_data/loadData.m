clear all
clc
fileID = fopen('.\data.sets\adenocarcinoma.class.txt','r');
formatSpec = '%i';
label = fscanf(fileID,formatSpec);
fclose(fileID);


fileID = fopen('.\data.sets\adenocarcinoma.data.txt','r');
% formatSpec = '%s';
% B = fscanf(fileID,formatSpec);
B = textscan(fileID,'%s\t');
fclose(fileID);

Data = B{1,1};
Data = ['ID';Data];
Data = reshape(Data, 77,[]);

rawData = Data(2:end,:);
rawData = rawData(:,2:end);
rawData = str2double(rawData);


tempPos = rawData(label==1, :);
randomPos = randperm(size(tempPos,1));
tempPos = tempPos(randomPos,:);

tempNeg = rawData(label==0, :);
randomNeg = randperm(size(tempNeg,1));
tempNeg = tempNeg(randomNeg,:);

tempPoslabel = label(label==1, :);
tempNeglabel = label(label==0, :);

rawData = [tempPos;tempNeg];
label = [tempPoslabel; tempNeglabel];
