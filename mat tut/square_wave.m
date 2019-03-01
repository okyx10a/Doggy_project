t = -4:0.01:4;
f = 0.5;
n = 1000;
y = 0;
for i = 1:2:n
    y = y + 4/(i*pi)*sin(i*pi*t*f);
end

figure
plot(t,y);