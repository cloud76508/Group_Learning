function [number_w, window_data] = partition_sd_v1(raw_data, w_size)

% partition for single digit, always partition a single digit as many
% windows
% sub-images
% partition the image using prefered window size
% the divided data would be used for Group Learning

%load('C:\Users\ASUS\Desktop\digit\negative\segment1.mat')
%w_size = 40;

%window_size_list = [20,32,35,50,55,60, 61, 62, 63];

if w_size < 61
    temp_w = floor((64-w_size)/5);
    number_w = (temp_w+1)*(temp_w+1);

    window_data = [];
    for n=1:temp_w+1
        for m=1:temp_w+1
            temp_data = raw_data((n-1)*5+1:(n-1)*5+w_size, (m-1)*5+1:(m-1)*5+w_size);
            window_data = [window_data,reshape(temp_data,[],1)];
        end
    end

else
    temp_w = 64-w_size;
    number_w = (temp_w+1)*(temp_w+1);

    window_data = [];
    for n=1:temp_w+1
        for m=1:temp_w+1
            temp_data = raw_data(n:n+w_size-1, m:m+w_size-1);
            window_data = [window_data,reshape(temp_data,[],1)];
        end
    end
end

%number_w = size(window_data,2);
