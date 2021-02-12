function [number_w, window_data] = partition_FP(raw_data, w_size)
%%%%fixed the start point of the window%%%%

% load('C:\Users\ASUS\Desktop\digit\negative\segment1.mat')
% raw_data = segment;
% w_size = 28;

% partition the image using prefered window size
% the divided data would be used for Group Learning

if mod(w_size,28) == 0 && w_size >= 28
    num_loss = ceil(w_size/28)-1; 
elseif mod(w_size,28) ~= 0 && w_size >= 28
    num_loss = ceil(w_size/28);
elseif w_size < 28
    num_loss = 0;
end

% res = mod(size(raw_data,1),w_size);
 temp_data = raw_data;
% temp_data(end-res+1:end,:) = [];
% temp_data(:,end-res+1:end) = [];

%display_network(reshape(segment,[],1))

window_data = [];
for n = 1:(size(temp_data,1)/28-num_loss)
   for m = 1:(size(temp_data,2)/28-num_loss)
        r_start = (n-1)*28+1;
        r_end = r_start+w_size-1;
        c_start = (m-1)*28+1;
        c_end = c_start+w_size-1;
        each_window = temp_data(r_start:r_end, c_start:c_end);
        window_data = [window_data,reshape(each_window,[],1)];
   end
end
number_w = size(window_data,2);


%imshow(reshape(window_data(:,3), sqrt(size(window_data,1)),sqrt(size(window_data,1))))