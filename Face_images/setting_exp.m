%Setting experiments
clear all
clc

%window_size = [30,40,50,60,80,120];
%window_size = 50;
window_size = [30,60,90,120];
repeat_num = 10;
training_error_ad = zeros(repeat_num,length(window_size));
test_error_ad = zeros(repeat_num,length(window_size));

training_error_ad_f = zeros(repeat_num,length(window_size));
test_error_ad_f = zeros(repeat_num,length(window_size));

training_error_mv = zeros(repeat_num,length(window_size));
test_error_mv = zeros(repeat_num,length(window_size));
training_error_SVM = zeros(repeat_num,length(window_size));
test_error_SVM = zeros(repeat_num,length(window_size));

c=[10^-3,10^-2,10^-1,10^0,10^1,10^2,10^3,10^4];

for n = 1:length(window_size)
%for n = 1:length(c)
    n
   for m = 1:repeat_num
       m
      [training_error_ad(m,n), test_error_ad(m,n)] = SVM_GL_adaptive(window_size(n));
      %[training_error_ad_f(m,n), test_error_ad_f(m,n)] = SVM_GL_adaptive_fixed_C(window_size(n));
       
      [training_error_mv(m,n), test_error_mv(m,n)] = SVM_GL_MV(window_size(n));

      %[training_error_SVM(m,n), test_error_SVM(m,n)] = Experiment_standardSVM_fixed_C(c(n));
   end
end