function show_digits_matrix(segment)
%for matrix original used for group learning

segment_raw = zeros(28*8,28*8);
i = 0;
j = 0;
for m = 1:size(segment,2)
    temp = segment(:,m);
    temp = reshape(temp,[28,28]);
    if j == 8 && i<8
        i = i+1;
        j = 0;
    end
    segment_raw(i*28+1:(i+1)*28,j*28+1:(j+1)*28) = temp;
    j = j+1;
end
segment = segment_raw;
imshow(segment);

clearvars -except images_five images_eight labels_five labels_eight