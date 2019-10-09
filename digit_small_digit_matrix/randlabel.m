function  [labels] = randlabel(size)
    labels = [];
    for n = 1: size
        labels = [labels; 1 - 2*round(rand)];
    end
end