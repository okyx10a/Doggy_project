[pks, locs] = findpeaks(Impedance7/100, Time7, 'MinPeakDistance', 1.7);
hold on
plot(Time7, Impedance7);
plot(locs,pks*100, 'rv');
disp(numel(pks));
xlabel('time(s)');
ylabel('impeadance(Ohms)');
legend('impeadance','peaks')
hold off