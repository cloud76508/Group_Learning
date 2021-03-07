clear all
clc

filename = 'D:\Handwritten_chinese\ETL\ETL8B\ETL8B2C1_11.png';
data = imread(filename);

%filename2 = 'D:\Handwritten_chinese\ETL\ETL8B\ETL8B2C1_00.txt';
%label = fileread(filename2);

character_numb = 10001;
for n = 1:40
    for m = 1:50
        character = [];
        character = data((n-1)*63+1:n*63, (m-1)*64+1:m*64);
        temp_name = sprintf('D:\\Handwritten_chinese\\ETL\\single_characters\\cn\\chr%d.mat',character_numb);
        save(temp_name,'character')
        character_numb = character_numb +1;
    end
end
