function [digit,num] = digitdata(data, gnd, d)
    index = 1;
    for i = 1:length(gnd)
        if gnd(i) == d
            digit(:,index) = data(:,i);
            index = index + 1;
        end
    end
    num = index-1;
end