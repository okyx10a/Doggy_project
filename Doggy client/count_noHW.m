%%
%Signal processing
%Parameter section 
cutoff_h = 5.5;
cutoff_window = cutoff_h+0.01;
MinPeakProminence = 0.5;
%Parameter section

fs = 1/(-mean(time(1:end-1)-time(2:end)));
l=length(brea);                      % series length
f_pos = fs*(0:(l/2))/l;              % single-sided positive frequency
brea_fft = fft(brea)/l;              % normalized fft
PSD=2*abs(brea_fft(1:l/2+1));       % one-sided amplitude spectrum

f_neg = fs*(-(l/2):0)/l;             % single-sided negative frequency
f = [f_neg(1:end-2+mod(l,2)),f_pos];
% constructing the filter
lowpass = zeros(1,l);
for n = 1:10
    lowpass = lowpass+(4/pi^2)*(((1-(-1)^n))/n^2)*ones(1,l).*(abs(f)>(n*cutoff_h-cutoff_window)&abs(f)<(n*cutoff_h));
end
%figure
%plot(f,lowpass);
brea_fft_filted = fftshift(brea_fft).*lowpass;
brea_filted = 1.5*real(ifft(ifftshift(brea_fft_filted*l)));

[pks, locs] = findpeaks(brea_filted/100, fs, 'MinPeakProminence',MinPeakProminence);
figure
hold on
plot(time,brea)
plot(time,brea_filted)
plot(locs,pks*100, 'bv');
xlabel('time(s)');
ylabel('ADC readings');
legend('orignal signal','filtered signal','peaks')
hold off
Breath_rate = numel(pks)/time(end)*60;
disp('the breath rate is: ');
disp(Breath_rate);