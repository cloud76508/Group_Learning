function [number_w, window_data] = partition(raw_data, w_size)

% partition the image using prefered window size
% the divided data would be used for Group Learning

%load('C:\Users\User\Desktop\digit_segment\small_matrix\positive\segment1.mat')
%w_size = 40;
res = mod(size(raw_data,1),w_size);
temp_data = raw_data;
temp_data(end-res+1:end,:) = [];
temp_data(:,end-res+1:end) = [];

%display_network(reshape(segment,[],1))

window_data = [];
for n = 1:size(temp_data,1)/w_size
   for m = 1:size(temp_data,2)/w_size
        r_start = (n-1)*w_size+1;
        r_end = n*w_size;
        c_start = (m-1)*w_size+1;
        c_end = m*w_size;
        each_window = temp_data(r_start:r_end, c_start:c_end);
        window_data = [window_data,reshape(each_window,[],1)];
   end
end
number_w = size(window_data,2);
