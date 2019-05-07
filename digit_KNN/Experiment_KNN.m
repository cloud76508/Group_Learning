clear all;
close all;
clc;

test_errors = [];
test_FPs = [];
test_FNs = [];
train_errors = [];
train_FPs = [];
train_FNs = [];
opt_ks = [];

train_tie_count = [];
test_tie_count = [];
test_errors_patch = [];
test_FPs_patch = [];
test_FNs_patch = [];
train_errors_patch = [];
train_FPs_patch = [];
train_FNs_patch = [];
opt_ks_patch = [];

ratioIndex = 1;

% K parameter of KNN
 k = [15:-2:3];
 k_patch = [15:-2:3];

for round =1:100
    
    [train, val, test, train_patch,val_patch,test_patch] = loadData_KNN_overlap(ratioIndex);
    
    val_errors = [];
    val_FNs = [];
    val_FPs = [];
    for n=1:length(k)
        Mdl = fitcknn(train.x, train.y,'NumNeighbors',k(n));
        valPredict = predict(Mdl,val.x);
        val_error =  sum(val.y ~= valPredict)/length(val.y);
        val_FN = sum(val.y(1:length(val.y)/2) ~= valPredict(1:length(val.y)/2));
        val_FP = sum(val.y(length(val.y)/2+1:end) ~= valPredict(length(val.y)/2+1:end));
        val_errors = [val_errors;val_error];
        val_FNs = [val_FNs; val_FN];
        val_FPs = [val_FPs; val_FP];
    end
    
    [Val_error I] = min(val_errors);
    opt_k = k(I)
    
    opt_Mdl = fitcknn(train.x, train.y,'NumNeighbors',opt_k);
    trainPredict = predict(opt_Mdl,train.x);
    train_error =  sum(train.y ~= trainPredict)/length(train.y)
    train_FN = sum(train.y(1:length(train.y)/2) ~= trainPredict(1:length(train.y)/2));
    train_FP = sum(train.y(length(train.y)/2+1:end) ~= trainPredict(length(train.y)/2+1:end));
    
    testPredict = predict(opt_Mdl,test.x);
    test_error =  sum(test.y ~= testPredict)/length(test.y)
    test_FN = sum(test.y(1:length(test.y)/2) ~= testPredict(1:length(test.y)/2));
    test_FP = sum(test.y(length(test.y)/2+1:end) ~= testPredict(length(test.y)/2+1:end));
    
    test_errors = [test_errors; test_error];
    test_FPs = [test_FPs; test_FP];
    test_FNs = [test_FNs;test_FN];
    train_errors = [train_errors;train_error];
    train_FPs = [train_FPs;train_FP];
    train_FNs = [train_FNs;train_FN];
    opt_ks = [opt_ks,opt_k];
    
    
    val_patch_errors = [];
    val_patch_FNs = [];
    val_patch_FPs = [];
    for n=1:length(k)
        Mdl_patch = fitcknn(train_patch.x, train_patch.y,'NumNeighbors',k(n));
        valPredict_patch = predict(Mdl_patch,val_patch.x);
        val_patch_error =  sum(val_patch.y ~= valPredict_patch)/length(val_patch.y);
        val_patch_FN = sum(val_patch.y(1:length(val_patch.y)/2) ~= valPredict_patch(1:length(val_patch.y)/2));
        val_patch_FP = sum(val_patch.y(length(val_patch.y)/2+1:end) ~= valPredict_patch(length(val_patch.y)/2+1:end));
        val_patch_errors = [val_patch_errors;val_patch_error];
        val_patch_FNs = [val_patch_FNs; val_patch_FN];
        val_patch_FPs = [val_patch_FPs; val_patch_FP];
    end
    
    [Val_patch_error I] = min(val_patch_errors);
    opt_patch_k = k_patch(I)
    
    opt_Mdl_patch = fitcknn(train_patch.x, train_patch.y,'NumNeighbors',opt_patch_k);
    trainPredict_patch = predict(opt_Mdl_patch,train_patch.x);
    
    tieTrain = 0;
    for n =1:size(trainPredict_patch,1)/4
       if sum(trainPredict_patch(4*(n-1)+1:4*n)) > 2  
           trainPredict_MV(n,1) = 1;
       elseif sum(trainPredict_patch(4*(n-1)+1:4*n)) < 2
           trainPredict_MV(n,1) = 0;
       else 
           tieTrain = tieTrain +1;
           randomOutput = randperm(2);
           trainPredict_MV(n,1) = randomOutput(1)-1;
       end
    end
    
    train_patch_error =  sum(train.y ~= trainPredict_MV)/length(train.y)
    train_patch_FN = sum(train.y(1:length(train.y)/2) ~= trainPredict_MV(1:length(train.y)/2));
    train_patch_FP = sum(train.y(length(train.y)/2+1:end) ~= trainPredict_MV(length(train.y)/2+1:end));
    
    testPredict_patch = predict(opt_Mdl_patch,test_patch.x);
    
    tieTest = 0;
    for n =1:size(testPredict_patch,1)/4
       if sum(testPredict_patch(4*(n-1)+1:4*n)) > 2  
           testPredict_MV(n,1) = 1;
       elseif sum(testPredict_patch(4*(n-1)+1:4*n)) < 2
           testPredict_MV(n,1) = 0;
       else
           tieTest = tieTest +1;
           randomOutput = randperm(2);
           testPredict_MV(n,1) = randomOutput(1)-1;
       end
    end
    
    
    test_error_patch =  sum(test.y ~= testPredict_MV)/length(test.y)
    test_FN_patch = sum(test.y(1:length(test.y)/2) ~= testPredict_MV(1:length(test.y)/2));
    test_FP_patch = sum(test.y(length(test.y)/2+1:end) ~= testPredict_MV(length(test.y)/2+1:end));
    
    test_tie_count = [test_tie_count; tieTest];
    test_errors_patch = [test_errors_patch; test_error_patch];
    test_FPs_patch = [test_FPs_patch; test_FP_patch];
    test_FNs_patch = [test_FNs_patch;test_FN_patch];
    
    train_tie_count = [train_tie_count; tieTrain];
    train_errors_patch = [train_errors_patch;train_patch_error];
    train_FPs_patch = [train_FPs_patch;train_patch_FP];
    train_FNs_patch = [train_FNs_patch;train_patch_FN];
    opt_ks_patch = [opt_ks_patch,opt_patch_k];
end

save(sprintf('C:\\Users\\User\\Desktop\\IJCNN\\digit_KNN\\Results\\Results_%d.mat',ratioIndex))




