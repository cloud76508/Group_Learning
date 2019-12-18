function [normalizedData,maxValue,minValue] = normalization(originalData)

maxValue = max(originalData);
minValue = min(originalData);

for n = 1:size(originalData,2)
    if maxValue(n) ~= minValue(n)
        normalizedData(:,n) =  (originalData(:,n) - minValue(n))/(maxValue(n) - minValue(n));
    else
        normalizedData(:,n) = 0;
    end
end
