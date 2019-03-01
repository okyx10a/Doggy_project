%load('C:\temp\measure.csv');
%time = measure(:,1);
%data = measure(:,2);
load('Preliminary testing.mat')
time = Time7;
data = Impedance7;%-mean(Impedance7);
cutoff_h = 1.3;
cutoff_window = 1.1;


fs = 1/(-mean(time(1:end-1)-time(2:end)));
l=length(data);                      % series length
f_pos = fs*(0:(l/2))/l;              % single-sided positive frequency
data_fft = fft(data)/l;              % normalized fft
PSD=2*abs(data_fft(1:l/2+1));       % one-sided amplitude spectrum

f_neg = fs*(-(l/2):0)/l;             % single-sided negative frequency
f = [f_neg(1:end-2+mod(l,2)),f_pos];
% constructing the filter
lowpass = zeros(1,l);
for n = 1:10
    lowpass = lowpass+(4/pi^2)*(((1-(-1)^n))/n^2)*ones(1,l).*(abs(f)>(n*cutoff_h-cutoff_window)&abs(f)<(n*cutoff_h));
end

data_fft_filted = fftshift(data_fft).*lowpass';
data_filted = 1.5*real(ifft(ifftshift(data_fft_filted*l)));
[pks, locs] = findpeaks(data_filted/100, time, 'MinPeakDistance', 1.5);
figure
hold on
plot(time,data)
plot(time,data_filted)
plot(locs,pks*100, 'bv');
xlabel('time(s)');
ylabel('impeadance(Ohms)');
legend('orignal signal','filtered signal','peaks')
hold off
%figure
%plot(f,lowpass);
xlabel('Frequencies');
ylabel('Amplification Ratio');
Breath_rate = numel(pks)/time(end)*60;
disp('the breath rate is: ');
disp(Breath_rate);
c = clock;
Date = strsplit(datestr(c),' ');


t = tcpip('192.168.137.32', 80);
fopen(t);
t.Status
fwrite(t, 1);
temperature = fscanf(t)
fclose(t);
if fopen('records.csv') == -1
    records = fopen('records.csv','w');
    fprintf(records, 'Date,Time,Breath_rate,Temperature\n');   
    fclose(records);
end
records = fopen('records.csv','a+');
fprintf(records, '%s,%s,%f,%s',Date{1},Date{2},Breath_rate,temperature);
fclose(records);

