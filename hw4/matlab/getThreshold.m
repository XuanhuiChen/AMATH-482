function threshold = getThreshold(s1,s2)
    t1 = length(s1);
    t2 = 1;
    while s1(t1) > s2(t2)
        t1 = t1-1;
        t2 = t2+1;
    end
    threshold = (s1(t1)+s2(t2))/2;
end

