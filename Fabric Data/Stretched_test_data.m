clear
load('Stretched_test_data.mat');
figure
semilogx(FrequencyHz,Z0);
title('Stretched fabric unloaded');
xlabel('FrequencyHz');
ylabel('MagnitudeOhms');
figure
%100ml beaker weighs 50g
semilogx(FrequencyHz,Z100);
title('Stretched fabric loaded with 100ml beaker');
xlabel('FrequencyHz');
ylabel('MagnitudeOhms');
figure
%300ml beaker weighs 60g
semilogx(FrequencyHz,Z300);
title('Stretched fabric loaded with 300ml beaker');
xlabel('FrequencyHz');
ylabel('MagnitudeOhms');
figure
%300ml beaker weighs 180g
semilogx(FrequencyHz,Z600);
title('Stretched fabric loaded with 600ml beaker');
xlabel('FrequencyHz');
ylabel('MagnitudeOhms');
figure
semilogx(FrequencyHz,Z100-Z0);
title('Stretched fabric: difference between 100ml beaker and unloaded');
xlabel('FrequencyHz');
ylabel('MagnitudeOhms');
del1 = mean(Z100(2:end)-Z0(2:end))
figure
semilogx(FrequencyHz,Z300-Z100);
title('Stretched fabric: difference between 300ml beaker and 100ml beaker');
xlabel('FrequencyHz');
ylabel('MagnitudeOhms');
del2 = mean(Z300(2:end)-Z100(2:end))
figure
semilogx(FrequencyHz,Z600-Z300);
title('Stretched fabric: difference between 600ml beaker and 300ml beaker');
xlabel('FrequencyHz');
ylabel('MagnitudeOhms');
del3 = mean(Z600(2:end)-Z300(2:end))
plot([del1,del2,del3]);