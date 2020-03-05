function [normalizedData,Value1,Value2] = normalization(originalData,method)

if method == 1 %Min-Max Feature scaling
    maxValue = max(originalData);
    minValue = min(originalData);
    
    for n = 1:size(originalData,2)
        if maxValue(n) ~= minValue(n)
            normalizedData(:,n) =  (originalData(:,n) - minValue(n))/(maxValue(n) - minValue(n));
        else
            normalizedData(:,n) = 0;
        end
    end
    Value1 = maxValue;
    Value2 = minValue;
end


if method == 2 %Standard score
    meanValue = mean(originalData);
    stdValue = std(originalData);
    
    for n = 1:size(originalData,2)
        if stdValue(n) ~= 0
            normalizedData(:,n) =  (originalData(:,n) - meanValue(n))/stdValue(n);
        else
            normalizedData(:,n) = 0;
        end
    end
    Value1 = meanValue;
    Value2 = stdValue;
end

