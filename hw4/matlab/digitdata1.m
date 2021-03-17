function digit1 = digitdata1(traindata, traingnd, digit)
    index = 1;
    for i = 1:length(traingnd)
        if traingnd(i) == digit
            digit1(:,index) = traindata(:,i);
        end
    end
end