clear; clc;

% Floyd
figure(1)
[y, Fs] = audioread('Floyd.m4a');
tr_flo = length(y)/Fs; % record time in seconds
plot((1:length(y))/Fs,y);
xlabel('Time [sec]'); ylabel('Amplitude');
title('Comfortably Numb');
print(gcf,'-dpng','cn.png');
%p8 = audioplayer(y,Fs); playblocking(p8);

% Part I: Initial conditions for drawing 1/4 fragment of spectrogram
tr_flo_s = tr_flo/4;
n_s = length(y)/4;
t2 = linspace(0,tr_flo_s,n_s+1);
t_1 = t2(1:n_s);
k = (1/tr_flo_s)*[0:n_s/2-1 -n_s/2:-1];
ks = fftshift(k);

S = y(1:n_s).';
St = fft(S);

% Part II: Use Gabor Transform to repeat the FFT and draw the spectrogram
figure(2)
a = [0.5 200];
tau = 0:0.2:tr_flo_s;
for i = 1:length(a)
    Sgt_spec = []; % Clear at each loop iteration
    for j = 1:length(tau)
        g = exp(-a(i)*(t_1 - tau(j)).^2); % Window function
        Sg = g.*S;
        Sgt = fft(Sg);
        Sgt_spec(j,:) = fftshift(abs(Sgt));
    end
    subplot(2,2,i)
    pcolor(tau,ks,Sgt_spec.')
    shading interp
    set(gca,'ylim',[0 1000],'Fontsize',16)
    colormap(hot) %colorbar
    xlabel('time (t) in sec'), ylabel('frequency (k) in Hz')
    title(['a = ',num2str(a(i))],'Fontsize',16)
    
    subplot(2,2,i+2)
    pcolor(tau,ks,(log(abs(Sgt_spec)+1)).')
    shading interp
    set(gca,'ylim',[0 1000],'Fontsize',16)
    colormap(hot) %colorbar
    xlabel('time (t) in sec'), ylabel('frequency (k) in Hz')
    title(['a = ',num2str(a(i)),' (Logrithm)' ],'Fontsize',16)
end


% Add in the Fourier transform of the whole signal
%Sgt_spec = [];
%Sgt_spec = repmat(fftshift(log(abs(Sgt)+1)),length(tau),1);
%subplot(2,1,2)
%pcolor(tau,ks,Sgt_spec.'),
%shading interp
%set(gca,'ylim',[0 1000],'Fontsize',16)
%colormap(hot) %colorbar
%xlabel('time (t)'), ylabel('frequency (k)')
%title('a = 0','Fontsize',16)

print(gcf,'-dpng','floyd_spec.png');

% Part III: music score for floyd

% a. Reset the initial conditions
n = length(y);
L = n/Fs;
t2 = linspace(0,tr_flo,n+1);
t = t2(1:n);
k = (1/tr_flo)*[0:n/2-1 -n/2:-1];
ks = fftshift(k);

S = y';
St = fft(S);

% b. Find each note by searching for the peak of the filter center:
a = [0.2 1500];
tau = 0:0.2:tr_flo;

for i = 1:length(a)
    Sgt_spec = []; % Clear at each loop iteration
    for j = 1:length(tau)
        g = exp(-a(i)*(t - tau(j)).^2); % Window function
        Sg = g.*S;
        Sgt = fft(Sg);
        [M,I] = max(Sgt);
        notes_flo(1,j) = abs(k(I));
    end
end

% c. The bass score
figure(3)
subplot(2,1,1)
notes_vec = [73.416,97.999,130.81,146.83,185,220,246.94];
plot(tau, notes_flo,'ro','MarkerFaceColor', 'r'); 
yticks(notes_vec); 
yticklabels({'D2','G2','C3','D3','#F3','A4','B4'});
ylim ([0 250])
title("Bass Score for Floyd");
xlabel("Time (s)"); 
ylabel("notes corresponding to frequency");
yyaxis right;
plot(tau, notes_flo,'ro','MarkerFaceColor', 'r'); 
ylabel("frequency(Hz)");
ylim ([0 250])
print(gcf,'-dpng','floyd_bass_notes.png');

% d. The guitar score:
subplot(2,1,2)
notes_vec = [261.63,293.66,369.99,440,493.88,587.33,659.26];
plot(tau, notes_flo,'ro','MarkerFaceColor', 'r'); 
yticks(notes_vec); 
yticklabels({'C4','D4','#F4','A5','B5','D5','E5'});
ylim ([250 700])
title("Guitar Score for Floyd");
xlabel("Time (s)"); 
ylabel("notes corresponding to frequency");
yyaxis right;
plot(tau, notes_flo,'ro','MarkerFaceColor', 'r'); 
ylabel("frequency(Hz)");
ylim ([250 700])
print(gcf,'-dpng','floyd_guitar_notes.png');