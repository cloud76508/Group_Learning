function [number_w, window_data] = partition_sd(raw_data, w_size)

% partition for single digit, always partition a single digit as four
% sub-images
% partition the image using prefered window size
% the divided data would be used for Group Learning

%load('C:\Users\ASUS\Desktop\digit\negative\segment1.mat')
%w_size = 40;

%display_network(reshape(segment,[],1))

window_data = [];
temp1 = raw_data(1:w_size, 1:w_size);
temp2 = raw_data(64-w_size+1:64, 1:w_size);
temp3 = raw_data(1:w_size,64-w_size+1:64);
temp4 = raw_data(64-w_size+1:64, 64-w_size+1:+64);
temp5 = raw_data(32-ceil(w_size/2)+1:32+floor(w_size/2), 32-ceil(w_size/2)+1:32+floor(w_size/2));
window_data = [reshape(temp1,[],1),reshape(temp2,[],1),reshape(temp3,[],1),reshape(temp4,[],1),reshape(temp5,[],1)];

number_w = size(window_data,2);
