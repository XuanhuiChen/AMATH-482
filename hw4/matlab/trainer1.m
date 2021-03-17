function [U,S,V,w,s1,s2] = trainer1(d1_data,d2_data,feature)
    n1 = size(d1_data,2);
    n2 = size(d2_data,2);
    [U,S,V] = svd([d1_data d2_data],'econ');
    digits = S*V';
    U = U(:,1:feature);
    d1 = digits(1:feature,1:n1);
    d2 = digits(1:feature,n1+1:n1+n2);
    m1 = mean(d1,2);
    m2 = mean(d2,2);
    
    Sw = 0;
    for i = 1:n1
        Sw = Sw + (d1(:,i)-m1)*(d1(:,i)-m1)';
    end
    for i = 1:n2
        Sw = Sw + (d2(:,i)-m2)*(d2(:,i)-m2)';
    end
    Sb = (m1-m2)*(m1-m2)';
    
    [V2,D] = eig(Sb,Sw);
    [~,ind] = max(abs(diag(D)));
    w = V2(:,ind);
    w = w/norm(w,2);
    v1 = w'*d1;
    v2 = w'*d2;
    
    if mean(v1)>mean(v2)
        w = -w;
        v1 = -v1;
        v2 = -v2;
    end
    
    s1 = sort(v1);
    s2 = sort(v2);
end

