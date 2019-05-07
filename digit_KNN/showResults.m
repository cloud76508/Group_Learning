clear all
clc

Ratio = 5;
load(sprintf('C:\\Users\\User\\Desktop\\IJCNN\\digit_KNN\\Results\\20by20\\Results_%d.mat', Ratio))

fprintf(sprintf('-----------------Test-----------------\n'))
fprintf(sprintf('standard FN = %.4f \n', mean(test_FNs)/250))

fprintf(sprintf('standard FP = %.4f \n',mean(test_FPs)/250))

fprintf(sprintf('standard Error = %.4f \n',mean(test_errors)))

fprintf(sprintf('group learning FN = %.4f \n', mean(test_FNs_patch)/250))

fprintf(sprintf('group learning FP = %.4f \n',mean(test_FPs_patch)/250))

fprintf(sprintf('group learning Error = %.4f \n',mean(test_errors_patch)))

fprintf(sprintf('-----------------Training-----------------\n'))
fprintf(sprintf('standard FN = %.4f \n', mean(train_FNs)/(Ratio*5)))

fprintf(sprintf('standard FP = %.4f \n',mean(train_FPs)/(Ratio*5)))

fprintf(sprintf('standard Error = %.4f \n',mean(train_errors)))

fprintf(sprintf('group learning FN = %.4f \n', mean(train_FNs_patch)/(Ratio*5)))

fprintf(sprintf('group learning FP = %.4f \n',mean(train_FPs_patch)/(Ratio*5)))

fprintf(sprintf('group learning Error = %.4f \n',mean(train_errors_patch)))

fprintf(sprintf('standard optiaml K = %.2f \n', mean(opt_ks)))

fprintf(sprintf('group optiaml K = %.2f \n', mean(opt_ks_patch)))

