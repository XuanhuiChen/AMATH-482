% Clean workspace
clear all; close all; clc

load subdata.mat % Imports the data as the 262144x49 (space by time) matrix called subdata 5

% Part 1a
L = 10; % spatial domain
n = 64; % Fourier modes
x2 = linspace(-L,L,n+1);
x = x2(1:n);
y = x; 
z = x;
k = (2*pi/(2*L))*[0:(n/2 - 1) -n/2:-1];
ks = fftshift(k);

[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(ks,ks,ks);

% Part 1b: Original Spatial and Spectral Resolution
figure(1)
for j=1:49
    Un(:,:,:)=reshape(subdata(:,j),n,n,n);
    M = max(abs(Un),[],'all');
    %close all；
    isosurface(X,Y,Z,abs(Un)/M,0.7)
    axis([-20 20 -20 20 -20 20]), grid on, drawnow
    pause(0.00001)
end
title("Spatial Raw Data");
xlabel('X');ylabel('Y');zlabel('Z');

% Part 2a: Average of the spectrum
Uave = zeros(n,n,n);
for j = 1:49
    Un(:,:,:)=reshape(subdata(:,j),n,n,n);
    Utn = fftn(Un);
    Uave = Uave + Utn;
end
Uave = fftshift(Uave)/49;

% Part 2b: Find the center frequency
[Y,index] = max(Uave(:));
[a,b,c] = ind2sub(size(Uave), index);
center_f = [ks(b), ks(a), ks(c)]; % center frequency

% draw the denoised data
% isosurface(Kx,Ky,Kz,abs(Uave)/max(abs(Uave(:))),0.7)

% Part 3: Filter
tau = 0.2;
filter = exp(-tau*((Kx-center_f(1)).^2 + (Ky-center_f(2)).^2 + ...
    (Kz-center_f(3)).^2));
track = zeros(49,3);

% Part 4: Path
for j = 1:49
    
    Un(:,:,:)=reshape(subdata(:,j),n,n,n);
    Unt = fftn(Un);
    Unft = filter .* fftshift(Unt); % filter out the center
    Unf = ifftn(Unft);
    
    [Y,index] = max(Unf(:));
    [a,b,c] = ind2sub(size(Unf), index);
    coordinates = [x(b), y(a), z(c)];
    track(j,:) = coordinates;
end
figure(2)
plot3(track(:,1), track(:,2), track(:,3), 'r-o'), grid on
title("Trajectory of the Submarine");
xlabel('x');ylabel('y');zlabel('z');

