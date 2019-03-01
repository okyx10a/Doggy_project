%%
%Data acquisition
clear
%Parameter section
measurement_time = 300;
%parameter section

t = tcpip('192.168.137.33', 80, 'NetworkRole','Client');
while ~strcmp(t.Status,'open')
    try
       fopen(t);
    catch ME
       disp('.');
    end  
end
t.Status
flushinput(t);
start_time = clock;
current_time = clock;
fwrite(t, 0);
brea = zeros(1,measurement_time*1000);
time = zeros(1,measurement_time*1000);
i = 1;
%trying to implement a non-existing do while loop
brea(i) = typecast(uint8(fread(t,[1,2],'uint8')),'uint16');
time(i) = typecast(uint8(fread(t,[1,4],'uint8')),'uint32');
while time(i)<measurement_time*1000     
    if t.BytesAvailable
        i = i+1;
        brea(i) = typecast(uint8(fread(t,[1,2],'uint8')),'uint16');
        time(i) = typecast(uint8(fread(t,[1,4],'uint8')),'uint32');        
    end   
    %current_time = clock;
end

fclose(t);
brea = brea(brea~=0);
time = time(time~=0);
plot(time/1000.0,brea);
%%
%Signal processing
%Parameter section 
cutoff_h = 10;
cutoff_window = cutoff_h+0.001;
MinPeakProminence = 0.35;
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
Breath_rate = numel(pks)/time(end)*60*1000;
disp('the breath rate is: ');
disp(Breath_rate);

%%
%Temperature
t = tcpip('192.168.137.33', 80);
while ~strcmp(t.Status,'open')
    try
       fopen(t);
    catch ME
       disp('.');
    end  
end
t.Status
fwrite(t, 1);
temperature = fgetl(t)
fclose(t);
%%
%Logging
c = clock;
Date = strsplit(datestr(c),' ')
if fopen('records.csv') == -1
    records = fopen('records.csv','w');
    fprintf(records, 'Date,Time,Breath_rate,Temperature\n');   
    fclose(records);
end
records = fopen('records.csv','a+');
fprintf(records, '%s,%s,%f,%s',Date{1},Date{2},Breath_rate,temperature);
fclose(records);