%Setting experiments
clear all
clc

window_size = [30,40,50,60,80,120];
%window_size = 50;
repeat_num = 20;
training_error_ad = zeros(repeat_num,length(window_size));
test_error_ad = zeros(repeat_num,length(window_size));
training_error_mv = zeros(repeat_num,length(window_size));
test_error_mv = zeros(repeat_num,length(window_size));

for n = 1:length(window_size)
    n
   for m = 1:repeat_num
       m
      [training_error_ad(m,n), test_error_ad(m,n)] = SVM_GL_adaptive(window_size(n));
      %training_error_ad(m,n) = train_error;
      %test_error_ad(m,n) = test_error;
  
      %[training_error_mv(m,n), test_error_mv(m,n)] = SVM_GL_MV(window_size(n));
      %training_error_mv(m,n) = train_error;
      %test_error_mv(m,n) = test_error;
   end
end