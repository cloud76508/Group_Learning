clear all
clc
for segNum = 1:600
    clearvars -except segNum 
    filePath = sprintf('C:\\Users\\User\\Desktop\\IJCNN\\digit\\negative\\partial\\segment%d.mat',segNum);
    load(filePath)
    
    feature = [];
    for w = 1:800
        feature(:,w) =segment(:,w);
        feature(1:784/2,w) = 0;
    end
    
    saveSegFeature = sprintf('C:\\Users\\User\\Desktop\\IJCNN\\digit\\Feature\\negative\\partial\\segFeature%d.mat',segNum);
    save(saveSegFeature,'feature')
end

for segNum = 1:600
    clearvars -except segNum 
    filePath = sprintf('C:\\Users\\User\\Desktop\\IJCNN\\digit\\positive\\partial\\segment%d.mat',segNum);
    load(filePath)
    
    feature = [];
    for w = 1:800
        feature(:,w) =segment(:,w);
        feature(1:784/2,w) = 0;
    end
    
    saveSegFeature = sprintf('C:\\Users\\User\\Desktop\\IJCNN\\digit\\Feature\\positive\\partial\\segFeature%d.mat',segNum);
    save(saveSegFeature,'feature')
end
