clear all; clc;

% Part I: Loading the data
% We can do the same procedures by simply change the movie file loaded in:
v = VideoReader('ski_drop.mov');
%v = VideoReader('monte_carlo.mov');
nf = v.NumberOfFrames;
X = [];

% Part I: Reformat the images
for i=1:nf
    img = double(rgb2gray(imresize(read(v,i), 0.2)));
    [m,n] = size(img);
    img = reshape(img, [m*n,1]);
    X = [X img];
end

t = linspace(0,v.CurrentTime, nf+1);
t = t(1:end-1);
dt = t(2)-t(1);

%% Part II: DMD Algorithm
X1 = X(:,1:end-1);
X2 = X(:,2:end);

[U,S,V] = svd(X1, 'econ'); %SVD

% Plot the engergy captured
figure(1)
plot(diag(S)/sum(diag(S)), 'r*');
title("Energies of Singular Values");
xlabel("Singular Values");
ylabel("Energy Captured"); 

% Truncate the matrices
r = 1;
U_r = U(:,1:r);
S_r = S(1:r,1:r);
V_r = V(:,1:r);

% Find approximate low-rank subspaces and psi
Atilde = (U_r'*X2*V_r)/S_r;
[W_r, D] = eig(Atilde);
phi = (X2 * V_r) / (S_r*W_r);
lambda = diag(D);
omega = log(lambda)/dt;

x1 = X1(:,1);
b = psi\x1;

t_d = zeros(r,length(t));
for j = 1:length(t)
    t_d(:,j) = (b.*exp(omega*t(j)));
end
X_bg = psi * t_d;

X_sparse = X-X_bg;
R = X_sparse .* (X_sparse<0);
X_fg = X_sparse - R;
X_low_dmd = R + abs(X_bg);


%% Part III: Draw one frame original video, its foreground and background
cap = 200; % randomly pick the frame

figure(2)
subplot(1,3,1)
img_o = reshape(X, [m, n, nf]);
imshow(uint8(img_o(:,:,cap)))
title("Original Video");

subplot(1,3,2)
img_bg = reshape(X_bg, [m, n, nf]);
imshow(uint8(img_bg(:,:,cap)))
title("Background");


subplot(1,3,3)
img_ob = reshape(X_fg(:,cap), [m, n]);
imshow(img_ob, []);
title("Foreground");


