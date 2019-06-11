clear all
clc

%Your local path of segment data
neg_image_path = 'C:\Users\User\Desktop\digit_segment\negative';
pos_image_path = 'C:\Users\User\Desktop\digit_segment\positive';
pos_diff_image_path = 'C:\Users\User\Desktop\digit_segment\positive_diff';

%Your local path for saving features
neg_feature_path = 'C:\Users\User\Desktop\digit_segment\feature\negative';
pos_feature_path = 'C:\Users\User\Desktop\digit_segment\feature\positive';
pos_diff_feature_path = 'C:\Users\User\Desktop\digit_segment\feature\positive_diff';


neg_image = dir(neg_image_path);
pos_image = dir(pos_image_path);
pos_diff_image = dir(pos_diff_image_path);

neg_image = neg_image(3:end);
num_neg_image = length(neg_image)/2;
neg_image = neg_image(num_neg_image+1:end);

pos_image = pos_image(3:end);
num_pos_image = length(pos_image)/2;
pos_image = pos_image(num_pos_image+1:end);

pos_diff_image = pos_diff_image(3:end);
num_pos_diff_image = length(pos_diff_image)/2;
pos_diff_image = pos_diff_image(num_pos_diff_image+1:end);

for segNum = 1:num_neg_image
    filePath = sprintf('%s\\segment%d.mat',neg_image_path,segNum);
    load(filePath)
    
    feature = [];
    for w = 1:800
        n = 1;
        for j = 1:14
            for i = 1:14
                feature(n,w) = (segment((i-1)*2+1 + (j-1)*2*28,w) + segment((i-1)*2+2 + (j-1)*2*28,w)...
                    + segment((i-1)*2+29 + (j-1)*2*28,w) + segment((i-1)*2+30 + (j-1)*2*28,w))/4;
                n = n+1;
            end
        end
    end
    
    saveSegFeature = sprintf('%s\\segFeature%d.mat',neg_feature_path,segNum);
    save(saveSegFeature,'feature')
end

for segNum = 1:num_pos_image
    filePath = sprintf('%s\\segment%d.mat',pos_image_path,segNum);
    load(filePath)
    
    feature = [];
    for w = 1:800
        n = 1;
        for j = 1:14
            for i = 1:14
                feature(n,w) = (segment((i-1)*2+1 + (j-1)*2*28,w) + segment((i-1)*2+2 + (j-1)*2*28,w)...
                    + segment((i-1)*2+29 + (j-1)*2*28,w) + segment((i-1)*2+30 + (j-1)*2*28,w))/4;
                n = n+1;
            end
        end
    end
    
    saveSegFeature = sprintf('%s\\segFeature%d.mat',pos_feature_path,segNum);
    save(saveSegFeature,'feature')
end

for segNum = 1:num_pos_diff_image
    filePath = sprintf('%s\\segment%d.mat', pos_diff_image_path,segNum);
    load(filePath)
    
    feature = [];
    for w = 1:800
        n = 1;
        for j = 1:14
            for i = 1:14
                feature(n,w) = (segment((i-1)*2+1 + (j-1)*2*28,w) + segment((i-1)*2+2 + (j-1)*2*28,w)...
                    + segment((i-1)*2+29 + (j-1)*2*28,w) + segment((i-1)*2+30 + (j-1)*2*28,w))/4;
                n = n+1;
            end
        end
    end
    
    saveSegFeature = sprintf('%s\\segFeature%d.mat',pos_diff_feature_path,segNum);
    save(saveSegFeature,'feature')
end

