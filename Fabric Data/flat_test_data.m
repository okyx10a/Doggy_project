clear
load('flat_test_data.mat');
figure
semilogx(FrequencyHz,Z0);
title('Flat unloaded');
xlabel('FrequencyHz');
ylabel('MagnitudeOhms');
figure
%600ml beaker plus 50ml water
semilogx(FrequencyHz,Z50);
title('flattened fabric loaded with 50ml beaker');
xlabel('FrequencyHz');
ylabel('MagnitudeOhms');
figure
%600ml beaker plus 100ml water
semilogx(FrequencyHz,Z100);
title('flattened fabric loaded with 100ml beaker');
xlabel('FrequencyHz');
ylabel('MagnitudeOhms');
figure
%600ml beaker plus 200ml water
semilogx(FrequencyHz,Z200);
title('flattened fabric loaded with 200ml beaker');
xlabel('FrequencyHz');
ylabel('MagnitudeOhms');
figure
%600ml beaker plus 500ml water
semilogx(FrequencyHz,Z500);
title('flattened fabric loaded with 500ml beaker');
xlabel('FrequencyHz');
ylabel('MagnitudeOhms');
figure
semilogx(FrequencyHz,Z50-Z0);
title('flattened fabric: difference between 50ml beaker and unloaded');
xlabel('FrequencyHz');
ylabel('MagnitudeOhms');
del1 = mean(Z50(2:end)-Z0(2:end))
figure
semilogx(FrequencyHz,Z100-Z50);
title('flattened fabric: difference between 100ml beaker and 50ml beaker');
xlabel('FrequencyHz');
ylabel('MagnitudeOhms');
del2 = mean(Z100(2:end)-Z50(2:end))
figure
semilogx(FrequencyHz,Z200-Z100);
title('flattened fabric: difference between 200ml beaker and 100ml beaker');
xlabel('FrequencyHz');
ylabel('MagnitudeOhms');
del3 = mean(Z200(2:end)-Z100(2:end))
figure
semilogx(FrequencyHz,Z500-Z200);
title('flattened fabric: difference between 500ml beaker and 200ml beaker');
xlabel('FrequencyHz');
ylabel('MagnitudeOhms');
del4 = mean(Z500(2:end)-Z200(2:end))
plot([del1,del2,del3,del4]);