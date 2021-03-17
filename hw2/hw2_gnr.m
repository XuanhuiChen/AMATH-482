%clear; clc;

% Part I: Initial Condition for GNR
figure(1)
[y, Fs] = audioread('GNR.m4a');
tr_gnr = length(y)/Fs; % record time in seconds
plot((1:length(y))/Fs,y);
xlabel('Time [sec]'); ylabel('Amplitude');
title('Sweet Child O Mine');
print(gcf,'-dpng','scom.png');
%p8 = audioplayer(y,Fs); playblocking(p8);

n = length(y);
L = n/Fs;
t2 = linspace(0,tr_gnr,n+1);
t = t2(1:n);
k = (1/tr_gnr)*[0:n/2-1 -n/2:-1];
ks = fftshift(k);

S = y';
St = fft(S);

% Part II: Use Gabor Transform to repeat the FFT and draw the spectrogram
figure(2)
a = 2000;
tau = 0:0.2:tr_gnr;
Sgt_spec = [];
% the center of filter changes everytime
for j = 1:length(tau)
	g = exp(-a*(t - tau(j)).^2); % Window function
	Sg = g.*S;
	Sgt = fft(Sg);
    [M,I] = max(Sgt);
    notes_gnr(1,j) = abs(k(I)); 
	Sgt_spec(j,:) = fftshift(abs(Sgt));
end

% Spectrogram for the larger a
subplot(2,2,1)
pcolor(tau,ks,Sgt_spec.')
shading interp
set(gca,'ylim',[0 1000],'Fontsize',16)
colormap(hot) %colorbar
xlabel('time (t) in sec'), ylabel('frequency (k) in Hz')
title(['a = ',num2str(a)],'Fontsize',16)

% Logrithm spectrogram for the larger a
subplot(2,2,3)
pcolor(tau,ks,(log(abs(Sgt_spec)+1)).')
shading interp
set(gca,'ylim',[0 1000],'Fontsize',16)
colormap(hot) %colorbar
xlabel('time (t) in sec'), ylabel('frequency (k) in Hz')
title(['a = ', num2str(a), ' (Logrithm)'],'Fontsize',16)


% Add in the Fourier transform of the whole signal

%Sgt_spec_l = [];
%Sgt_spec_l = repmat(fftshift(log(abs(St)+1)),length(tau),1);
Sgt_spec = [];
Sgt_spec = repmat(fftshift(abs(St)),length(tau),1);

% Spectrogram for a = 0
subplot(2,2,2)
pcolor(tau,ks,Sgt_spec.'),
shading interp
set(gca,'ylim',[0 1000],'Fontsize',16)
colormap(hot) %colorbar
xlabel('time (t) in sec'), ylabel('frequency (k) in Hz')
title('a = 0','Fontsize',16)

% Logrithm spectrogram for a = 0
subplot(2,2,4)
pcolor(tau,ks,(log(abs(Sgt_spec)+1)).'),
shading interp
set(gca,'ylim',[0 1000],'Fontsize',16)
colormap(hot) %colorbar
xlabel('time (t) in sec'), ylabel('frequency (k) in Hz')
title('a = 0 (Logrithm)','Fontsize',16)

print(gcf,'-dpng','gnr_spec.png');


% Part III: Music score for the GNR
figure(3)
notes_vec = [261.63,277.18,293.66,311.13,369.99,415.3,440];
plot(tau, notes_gnr,'ro','MarkerFaceColor', 'r'); 
yticks(notes_vec); 
yticklabels({'C4','#C4','D4','#D4','#F4','#G4','A5'});
ylim ([200 500])
title("Score for GNR");
xlabel("Time (s)"); 
ylabel("notes corresponding to frequency");
yyaxis right;
plot(tau, notes_gnr,'ro','MarkerFaceColor', 'r'); 
ylabel("frequency(Hz)");
ylim ([200 500])
print(gcf,'-dpng','gnr_notes.png');