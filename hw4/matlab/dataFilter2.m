function [accuracy2,row,col] = acc2(traindata,traingnd,testdata,testgnd,rank)
     for i=1:9
        [d1,~] = digitdata(traindata, traingnd,i);
        [t1,l1] = digitdata(testdata,testgnd,i);
        for j=1:9
            if j<=i
                accuracy2(j,i) = 0;
                continue
            end
            [d2,~] = digitdata(traindata, traingnd,j);
            [U,~,~,w,s1,s2] = trainer1(d1,d2,rank);
            threshold = getThreshold(s1,s2);
        
            [t2, l2] = digitdata(testdata,testgnd,j);
            testD = [t1 t2];

            testL = zeros(l1+l2,1);
            testL(l1+1:l1+l2) = 1;

            testNum = size(testD,2);
            testMat = U'*testD;
            pval = w'*testMat;
            resVec = (pval > threshold);
            err = abs(resVec - testL');
            errNum = sum(err);
            sucRate = 1 - errNum/testNum;
        
            accuracy2(j,i) = sucRate;
        end
     end

    % find best match number
    maximum = max(max(accuracy2));
    [row,col]=find(accuracy2==maximum);
end