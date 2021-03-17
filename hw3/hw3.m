% Test 1
clear all; close all; clc;

load('cam1_1.mat')
load('cam2_1.mat')
load('cam3_1.mat')

frame1 = size(vidFrames1_1,4); 
frame2 = size(vidFrames2_1,4); 
frame3 = size(vidFrames3_1,4); 

%for j = 1:frame1
    %X = vidFrames1_1(:,:,:,j);
    %imshow(X); drawnow
%end

%% Test 1: Camera 1
filter = zeros(480, 640);
filter(170:430, 300:400) = 1;

data1 = zeros(frame1, 2);
for j = 1:frame1
    X = vidFrames1_1(:,:,:,j);
    Xg = double(rgb2gray(X));
    Xf = Xg.*filter;
    thres = Xf > 250;
    
    [Y, X] = find(thres);
    data1(j,1) = mean(X);
    data1(j,2) = mean(Y);
end

%% Test 1: Camera 2
filter = zeros(480, 640);
filter(100:400, 230:360) = 1;

data2 = zeros(frame2, 2);
for j = 1:frame2
    X = vidFrames2_1(:,:,:,j);
    Xg = double(rgb2gray(X));
    Xf = Xg.*filter;
    thres = Xf > 250;
    
    [Y, X] = find(thres);
    data2(j,1) = mean(X);
    data2(j,2) = mean(Y);
end

%% Test 1: Camera 3
filter = zeros(480, 640);
filter(220:350, 250:500) = 1;

data3 = zeros(frame3, 2);
for j = 1:frame3
    X = vidFrames3_1(:,:,:,j);
    Xg = double(rgb2gray(X));
    Xf = Xg.*filter;
    thres = Xf > 245;
    
    [Y, X] = find(thres);
    data3(j,1) = mean(X);
    data3(j,2) = mean(Y);
end

%% Organize the data into 1 matrix
[M,I] = min(data1(1:20,2));
data1 = data1(I:end,:);
[M,I] = min(data2(1:20,2));
data2 = data2(I:end,:);
[M,I] = min(data3(1:20,2));
data3 = data3(I:end,:);

% data1 has the least values
data2 = data2(1:length(data1), :);
data3 = data3(1:length(data1), :);

data = [data1'; data2'; data3'];

%% Test1 Results
[m,n]= size(data);  

data = data-repmat(mean(data,2),1,n);  
[U,S,V]= svd(data'/sqrt(n-1));  
lambda = diag(S).^2; 
Y = data' * V;  

% Test1: graphs
figure(1)
plot(1:6, lambda/sum(lambda), 'c*--', 'Linewidth', 3);
title("Case 1: Variance and Diagonal energy");
xlabel("Diagonal Variances"); ylabel("Energy Level");

figure(2)
subplot(2,1,1)
plot(1:length(data), data(2,:), 1:length(data), data(1,:), 'Linewidth', 3)
ylabel("Displacement(pixels)"); xlabel("Time(frames)");
title("Case 1: Displacement along Z axis and XY-plane");
legend("Z", "XY")
subplot(2,1,2)
plot(1:length(data), Y(:,1),'r','Linewidth', 3)
ylabel("Displacement(pixels)"); xlabel("Time(frames)");
title("Case 1: Displacement along principal component directions");
legend("PC 1")

%% Test 2
clear all; close all; clc;

load('cam1_2.mat')
load('cam2_2.mat')
load('cam3_2.mat')

frame1 = size(vidFrames1_2,4); 
frame2 = size(vidFrames2_2,4); 
frame3 = size(vidFrames3_2,4); 

%for j = 1:frame1
    %X = vidFrames1_1(:,:,:,j);
    %imshow(X); drawnow
%end

%% Test 2: Camera 1
filter = zeros(480, 640);
filter(170:430, 300:450) = 1;

data1 = zeros(frame1, 2);
for j = 1:frame1
    X = vidFrames1_2(:,:,:,j);
    Xg = double(rgb2gray(X));
    Xf = Xg.*filter;
    thres = Xf > 250;
    
    [Y, X] = find(thres);
    data1(j,1) = mean(X);
    data1(j,2) = mean(Y);
end

%% Test 2: Camera 2
filter = zeros(480, 640);
filter(50:470, 170:440) = 1;

data2 = zeros(frame2, 2);
for j = 1:frame2
    X = vidFrames2_2(:,:,:,j);
    Xg = double(rgb2gray(X));
    Xf = Xg.*filter;
    thres = Xf > 248;
    
    [Y, X] = find(thres);
    data2(j,1) = mean(X);
    data2(j,2) = mean(Y);
end

%% Test 2: Camera 3
filter = zeros(480, 640);
filter(150:350, 250:500) = 1;

data3 = zeros(frame3, 2);
for j = 1:frame3
    X = vidFrames3_2(:,:,:,j);
    Xg = double(rgb2gray(X));
    Xf = Xg.*filter;
    thres = Xf > 245;
    
    [Y, X] = find(thres);
    data3(j,1) = mean(X);
    data3(j,2) = mean(Y);
end

%% Organize the data into 1 matrix
[M,I] = min(data1(1:20,2));
data1 = data1(I:end,:);
[M,I] = min(data2(1:20,2));
data2 = data2(I:end,:);
[M,I] = min(data3(1:20,2));
data3 = data3(I:end,:);

% data1 has the least values
data2 = data2(1:length(data1), :);
data3 = data3(1:length(data1), :);

data = [data1'; data2'; data3'];

%% Test2 Results
[m,n]= size(data);  

data = data-repmat(mean(data,2),1,n);  
[U,S,V]= svd(data'/sqrt(n-1));  
lambda = diag(S).^2; 
Y = data' * V;  

% Test2: graphs
figure(3)
plot(1:6, lambda/sum(lambda), 'g*--', 'Linewidth', 3);
title("Case 2: Variance and Diagonal Energy");
xlabel("Diagonal Variances"); ylabel("Energy Level");

figure(4)
subplot(2,1,1)
plot(1:length(data), data(2,:), 1:length(data), data(1,:), 'Linewidth', 3)
ylabel("Displacement(pixels)"); xlabel("Time(frames)");
title("Case 2: Original displacement along Z axis and XY-plane");
legend("Z", "XY")
subplot(2,1,2)
plot(1:length(data), Y(:,1), 1:length(data), Y(:,2),'m','Linewidth', 3)
ylabel("Displacement(pixels)"); xlabel("Time(frames)");
title("Case 2: Displacement along principal component directions");
legend("PC 1", "PC 2")

%% Test 3
clear all; close all; clc;

load('cam1_3.mat')
load('cam2_3.mat')
load('cam3_3.mat')

frame1 = size(vidFrames1_3,4); 
frame2 = size(vidFrames2_3,4); 
frame3 = size(vidFrames3_3,4); 

%for j = 1:frame1
    %X = vidFrames1_1(:,:,:,j);
    %imshow(X); drawnow
%end

%% Test 3: Camera 1
filter = zeros(480, 640);
filter(220:450, 270:400) = 1;

data1 = zeros(frame1, 2);
for j = 1:frame1
    X = vidFrames1_3(:,:,:,j);
    Xg = double(rgb2gray(X));
    Xf = Xg.*filter;
    thres = Xf > 250;
    
    [Y, X] = find(thres);
    data1(j,1) = mean(X);
    data1(j,2) = mean(Y);
end

%% Test 3: Camera 2
filter = zeros(480, 640);
filter(150:400, 240:420) = 1;

data2 = zeros(frame2, 2);
for j = 1:frame2
    X = vidFrames2_3(:,:,:,j);
    Xg = double(rgb2gray(X));
    Xf = Xg.*filter;
    thres = Xf > 248;
    
    [Y, X] = find(thres);
    data2(j,1) = mean(X);
    data2(j,2) = mean(Y);
end

%% Test 3: Camera 3
filter = zeros(480, 640);
filter(150:350, 250:500) = 1;

data3 = zeros(frame3, 2);
for j = 1:frame3
    X = vidFrames3_3(:,:,:,j);
    Xg = double(rgb2gray(X));
    Xf = Xg.*filter;
    thres = Xf > 245;
    
    [Y, X] = find(thres);
    data3(j,1) = mean(X);
    data3(j,2) = mean(Y);
end

%% Organize the data into 1 matrix
[M,I] = min(data1(1:20,2));
data1 = data1(I:end,:);
[M,I] = min(data2(1:20,2));
data2 = data2(I:end,:);
[M,I] = min(data3(1:20,2));
data3 = data3(I:end,:);

% data1 has the least values
data1 = data1(1:length(data3), :);
data2 = data2(1:length(data3), :);

data = [data1'; data2'; data3'];

%% Test3 Results
[m,n]= size(data);  

data = data-repmat(mean(data,2),1,n);  
[U,S,V]= svd(data'/sqrt(n-1));  
lambda = diag(S).^2; 
Y = data' * V;  

% Test3: graphs
figure(5)
plot(1:6, lambda/sum(lambda), 'g*--', 'Linewidth', 3);
title("Case 3: Variance and Diagonal Energy");
xlabel("Diagonal Variances"); ylabel("Energy Level");

figure(6)
subplot(2,1,1)
plot(1:length(data), data(2,:), 1:length(data), data(1,:), 'Linewidth', 3)
ylabel("Displacement(pixels)"); xlabel("Time(frames)");
title("Case 3: Original displacement along Z axis and XY-plane");
legend("Z", "XY")
subplot(2,1,2)
plot(1:length(data), Y(:,1), 1:length(data), Y(:,2), 1:length(data), ...
    Y(:,3), 1:length(data), Y(:,4), 'm','Linewidth', 3)
ylabel("Displacement(pixels)"); xlabel("Time(frames)");
title("Case 3: Displacement along principal component directions");
legend("PC 1", "PC 2", "PC 3", "PC 4")

%% Test 4
clear all; close all; clc;

load('cam1_4.mat')
load('cam2_4.mat')
load('cam3_4.mat')

frame1 = size(vidFrames1_4,4); 
frame2 = size(vidFrames2_4,4); 
frame3 = size(vidFrames3_4,4); 

%for j = 1:frame1
    %X = vidFrames1_1(:,:,:,j);
    %imshow(X); drawnow
%end

%% Test 4: Camera 1
filter = zeros(480, 640);
filter(200:450, 300:480) = 1;

data1 = zeros(frame1, 2);
for j = 1:frame1
    X = vidFrames1_4(:,:,:,j);
    Xg = double(rgb2gray(X));
    Xf = Xg.*filter;
    thres = Xf > 245;
    
    [Y, X] = find(thres);
    data1(j,1) = mean(X);
    data1(j,2) = mean(Y);
end

%% Test 4: Camera 2
filter = zeros(480, 640);
filter(100:400, 220:420) = 1;

data2 = zeros(frame2, 2);
for j = 1:frame2
    X = vidFrames2_4(:,:,:,j);
    Xg = double(rgb2gray(X));
    Xf = Xg.*filter;
    thres = Xf > 248;
    
    [Y, X] = find(thres);
    data2(j,1) = mean(X);
    data2(j,2) = mean(Y);
end

%% Test 4: Camera 3
filter = zeros(480, 640);
filter(130:300, 300:500) = 1;

data3 = zeros(frame3, 2);
for j = 1:frame3
    X = vidFrames3_4(:,:,:,j);
    Xg = double(rgb2gray(X));
    Xf = Xg.*filter;
    thres = Xf > 230;
    
    [Y, X] = find(thres);
    data3(j,1) = mean(X);
    data3(j,2) = mean(Y);
end

%% Organize the data into 1 matrix
[M,I] = min(data1(1:20,2));
data1 = data1(I:end,:);
[M,I] = min(data2(1:20,2));
data2 = data2(I:end,:);
[M,I] = min(data3(1:20,2));
data3 = data3(I:end,:);

% data1 has the least values
data1 = data1(1:length(data3), :);
data2 = data2(1:length(data3), :);

data = [data1'; data2'; data3'];

%% Test4 Results
[m,n]= size(data);  

data = data-repmat(mean(data,2),1,n);  
[U,S,V]= svd(data'/sqrt(n-1));  
lambda = diag(S).^2; 
Y = data' * V;  

% Test4: graphs
figure(7)
plot(1:6, lambda/sum(lambda), 'g*--', 'Linewidth', 3);
title("Case 4: Variance and Diagonal Energy");
xlabel("Diagonal Variances"); ylabel("Energy Level");

figure(8)
subplot(2,1,1)
plot(1:length(data), data(2,:), 1:length(data), data(1,:), 'Linewidth', 3)
ylabel("Displacement(pixels)"); xlabel("Time(frames)");
title("Case 4: Original displacement along Z axis and XY-plane");
legend("Z", "XY")
subplot(2,1,2)
plot(1:length(data), Y(:,1), 1:length(data), Y(:,2), 1:length(data), ...
    Y(:,3), 'm','Linewidth', 3)
ylabel("Displacement(pixels)"); xlabel("Time(frames)");
title("Case 4: Displacement along principal component directions");
legend("PC 1", "PC 2", "PC 3")

