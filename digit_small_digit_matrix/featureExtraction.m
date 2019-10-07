clear all
clc
for segNum = 1:1000
    clearvars -except segNum 
    filePath = sprintf('C:\\Users\\User\\Desktop\\digit\\negtive\\segment%d.mat',segNum);
    load(filePath)
    
    feature = [];
    for w = 1:800
        n = 1;
        for j = 1:14
            for i = 1:14
                feature(n,w) = (segment((i-1)*2+1 + (j-1)*2*28,w) + segment((i-1)*2+2 + (j-1)*2*28,w)...
                    + segment((i-1)*2+29 + (j-1)*2*28,w) + segment((i-1)*2+30 + (j-1)*2*28,w))/4;
                n = n+1;
                %         (i-1)*2+1 + (j-1)*2*28
                %         (i-1)*2+2 + (j-1)*2*28
                %         (i-1)*2+29 + (j-1)*2*28
                %         (i-1)*2+30 + (j-1)*2*28
            end
        end
    end
    
    saveSegFeature = sprintf('C:\\Users\\User\\Desktop\\digit\\Feature\\negtive\\segFeature%d.mat',segNum);
    save(saveSegFeature,'feature')
end