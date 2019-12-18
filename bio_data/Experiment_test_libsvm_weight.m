clear all;
close all;
clc;
%loadData
loadData

rawData = normalization(rawData);

%randOrder = randperm(length(label));
% data.X = rawData(randOrder,:);
% data.y = label(randOrder,1);

data.X = rawData(55:end,10:20);
data.y = label(55:end);

% -wi, i should consistent with the label

%Example1: set -w0 -w+1, when label of two classes are 0 and 1 
mdl = svmtrain(data.y, data.X,'-w0 0.00001 -w+1 0.00001 -c 100000 -t 1 ');
[pred, ~, ~] = svmpredict(data.y, sparse(data.X), mdl);
pred

%Example2: set -w-1 -w+1, when label of two classes are 0 and 1 
mdl2 = svmtrain(data.y, data.X,'-w-1 0.00001 -w+1 0.00001 -c 100000 -t 1 ');
[pred, ~, ~] = svmpredict(data.y, sparse(data.X), mdl2);
pred

%Example3: only set -w+1,  when label of two classes are 0 and 1
mdl3 = svmtrain(data.y, data.X,'-w+1 0.00001 -c 100000 -t 1 ');
[pred, ~, ~] = svmpredict(data.y, sparse(data.X), mdl3);
pred

%Example 2 and 3 generate the same results, which shows the inconsistent wi
%doesn't work. 