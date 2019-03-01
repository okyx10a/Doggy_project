t = 1:0.1:120;
x = sawtooth(2*pi*0.5*t,0.5);
fs = 1/(-mean(time(1:end-1)-time(2:end)));
l=length(x);                      % series length
f_pos = fs*(0:(l/2))/l;              % single-sided positive frequency
x_fft = fft(x,l)/l;              % normalized fft
PSD=2*abs(x_fft(1:l/2+1)); 
%plot(t,x);
plot(f_pos,PSD);