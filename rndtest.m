%%
%Data acquisition
clear
%Parameter section
measurement_time = 30;
%parameter section
records = fopen('measurements.csv','w');
t = tcpip('192.168.137.32', 80, 'NetworkRole','Client');
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
while etime(current_time,start_time)<measurement_time    
fscanf(t)
current_time = clock;
end
fwrite(t,2);
fclose(t);
fclose(records);
dat = csvread('measurements.csv');
brea = dat(:,1)';
time = dat(:,2)';
disp('done')