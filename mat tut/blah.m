t = [-4:0.1:4];
f = 0.5;
y = 0;
for i = 1:2:3
    y = y + 4/(i*pi)*sin(2*pi*i*f*t);
end
plot(t,y);