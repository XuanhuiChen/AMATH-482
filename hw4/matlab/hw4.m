clear all; close all; clc;

% Part I: Loading mnist data and reshape it into column vectors
[traindata, traingnd] = mnist_parse('train-images.idx3-ubyte', ...
    'train-labels.idx1-ubyte');
traindata = double(reshape(traindata, ...
    size(traindata,1)*size(traindata,2), []));
traingnd = double(traingnd);

[testdata, testgnd] = ...
    mnist_parse('t10k-images.idx3-ubyte', 't10k-labels.idx1-ubyte');
testdata = ...
    double(reshape(testdata, size(testdata,1)*size(testdata,2), []));
testgnd = double(testgnd);

% Part I: SVD analysis
[m,n]= size(traindata); 
train = traindata-repmat(mean(traindata,2),1,n);  
[U,S,V]= svd(train/sqrt(n-1), 'econ');
sig = diag(S);
energy = sig.^2/sum(sig.^2);

% Part I: Singular value spectrum and rank r
figure(1)
subplot(2,1,1)
plot(sig,'ro','Linewidth',0.3)
ylabel('sigma')
%set(gca,'Fontsize',16,'Xlim',[0 80])
title('Singular Value Spectrum')
subplot(2,1,2)
plot(energy ,'ro','Linewidth',0.3)
ylabel('energy')
%set(gca,'Fontsize',16,'Xlim',[0 80])

total_energy = 0;
for i = 1:length(energy)
    total_energy = total_energy + energy(i);
    if total_energy > 0.9
        break
    end
end
rank = i;

% Part I: 3-D projection onto selected V-modes
figure(2)
for index = 0:9
    label = find(traingnd == index);
    plot3(V(label, 2), V(label, 3), V(label, 5),...
        'o', 'DisplayName', sprintf('%i',index), 'Linewidth', 2)
    hold on
end
xlabel('2nd V-mode'), ylabel('3rd V-mode'), zlabel('5th V-mode')
title('Projection onto Selected V-modes')
legend
set(gca,'Fontsize', 10)

% Part II: LDA on two digits
[d1, n1] = digitdata(traindata, traingnd,2);
[d2, n2] = digitdata(traindata, traingnd,7);
[U,S,V,w,s1,s2] = trainer1(d1,d2,rank);
threshold = getThreshold(s1,s2);

figure(2)
subplot(1,2,1)
histogram(s1,30); hold on, plot([threshold threshold], [0 1000],'r')
title('2')
subplot(1,2,2)
histogram(s2,30); hold on, plot([threshold threshold], [0 1000],'r')
title('7')

% Part II: accuracy of LDA on separating the two digits
[t1, l1] = digitdata(testdata,testgnd,2);
[t2, l2] = digitdata(testdata,testgnd,7);
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


% Part II: LDA on three digits
[d1,n1] = digitdata(traindata, traingnd,4);
[d2,n2] = digitdata(traindata, traingnd,5);
[d3,n3] = digitdata(traindata, traingnd,6);
[U,S,V,w,s1,s2,s3] = trainer2(d1,d2,d3,rank);
threshold1 = getThreshold(s2,s3);
threshold2 = getThreshold(s3,s1);



figure(3)
subplot(2,2,1)
histogram(s1,30); hold on, plot([threshold2 threshold2], [0 1200],'r')
title('4')
subplot(2,2,2)
histogram(s3,30); hold on, plot([threshold2 threshold2], [0 1200],'r')
title('6')
subplot(2,2,3)
histogram(s3,30); hold on, plot([threshold1 threshold1], [0 1200],'r')
title('6')
subplot(2,2,4)
histogram(s2,30); hold on, plot([threshold1 threshold1], [0 1200],'r')
title('5')

% Part III: Accuracy on two digits
[accuracy2,row,col] = acc2(traindata,traingnd,testdata,testgnd,rank);

% Part III: Accuracy on three digits
[accuracy3,num1,num2,num3] = acc3(traindata,traingnd,testdata,testgnd,rank);

% Part IV: SVM and decision tree classifiers
digits=fitctree(traindata,trainlabel,'MaxNumSplits',3,'CrossVal','on');
view(tree.Trained{1},'Mode','graph');
classError = kfoldLoss(tree);

% SVM classifier with training data, labels and test set
Mdl = fitcsvm(xtrain,label);
test_labels = predict(Mdl,test);