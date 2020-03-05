clear all
clc
fileID = fopen('.\data.sets\colon.class.txt','r');
label = textscan(fileID,'%s\t');
fclose(fileID);
label = label{1,1};


fileID = fopen('.\data.sets\colon.data.txt','r');
% formatSpec = '%s';
% B = fscanf(fileID,formatSpec);
B = textscan(fileID,'%s\t');
fclose(fileID);

Data = B{1,1};
Data = reshape(Data, 63,[]);

rawData = Data(2:end,:);
rawData = rawData(:,2:end);
rawData = str2double(rawData);

tempLabel = [];
for n = 1:size(label,1)
    if length(label{n,1}) ==6
        tempLabel = [tempLabel; 0];
    else
        tempLabel = [tempLabel; 1];
    end
end

label = tempLabel;

tempPos = rawData(label==1, :);
tempNeg = rawData(label==0, :);
rawData = [tempPos;tempNeg];

