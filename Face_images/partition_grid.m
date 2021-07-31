function [number_w, window_data] = partition_grid(raw_data, w_size)

% partition for single digit, always partition a single digit as many
% windows
% sub-images
% partition the image using prefered window size
% the divided data would be used for Group Learning

%size = 240*320
%example: raw_data =
%raw_data=imread('D:\yalefaces_negative\subject01.leftlight.gif');
%raw_data = raw_data(4:end,:);
%raw_data = im2double(raw_data);

slide = 30;
%x_w = floor((240-w_size)/slide);
%y_w = floor((320-w_size)/slide);
x_w = floor((160-w_size)/slide);
y_w = floor((160-w_size)/slide);
number_w = (x_w+1)*(y_w+1);

window_data = [];
for n=1:x_w+1
    for m=1:y_w+1
        x_start = (n-1)*slide+1; 
        x_end = (n-1)*slide+w_size;
        y_start = (m-1)*slide+1;
        y_end = (m-1)*slide+w_size;
        temp_data = raw_data(x_start:x_end,y_start:y_end);
        window_data = [window_data,reshape(temp_data,[],1)];
    end
end

%number_w = size(window_data,2);
