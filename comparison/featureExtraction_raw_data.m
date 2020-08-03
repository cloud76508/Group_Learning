clear all
clc
for segNum = 1:600
    clearvars -except segNum 
    filePath = sprintf('C:\\Users\\User\\Desktop\\IJCNN\\digit\\negative\\V1\\segment%d.mat',segNum);
    load(filePath)
    
    feature = [];
    feature = segment;
    
    saveSegFeature = sprintf('C:\\Users\\User\\Desktop\\IJCNN\\digit\\Feature\\negative\\V1\\segFeature%d.mat',segNum);
    save(saveSegFeature,'feature')
end

for segNum = 1:600
    clearvars -except segNum 
    filePath = sprintf('C:\\Users\\User\\Desktop\\IJCNN\\digit\\positive\\V1\\segment%d.mat',segNum);
    load(filePath)
    
    feature = [];
    feature = segment;
    
    saveSegFeature = sprintf('C:\\Users\\User\\Desktop\\IJCNN\\digit\\Feature\\positive\\V1\\segFeature%d.mat',segNum);
    save(saveSegFeature,'feature')
end
