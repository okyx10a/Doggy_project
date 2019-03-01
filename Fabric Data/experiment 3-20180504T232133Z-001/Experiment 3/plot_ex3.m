%% back to back 
figure
semilogx(f,Zb2b1,'r',f,Zb2b2,'r--',f,Zb2b3,'r-.',f,Zb2bl1,'b',f,Zb2bl2,'b--',f,Zb2bl3,'b-.');
legend('unloaded 1','unloaded 2','unloaded 3','loaded 1','loaded 2','loaded 3');
xlabel('Frequency(Hz)');
ylabel('Impeadance Magnitude(Ohm)');
title('back to back magnitude plot');

figure
semilogx(f,Phb2b1,'r',f,Phb2b2,'r--',f,Phb2b3,'r-.',f,Phb2bl1,'b',f,Phb2bl2,'b--',f,Phb2bl3,'b-.');
legend('unloaded 1','unloaded 2','unloaded 3','loaded 1','loaded 2','loaded 3');
xlabel('Frequency(Hz)');
ylabel('Impeadance Phase(deg)');
title('back to back phase plot');
%% back to back with interface
figure
semilogx(f,Zb2bi1,'r',f,Zb2bi2,'r--',f,Zb2bi3,'r-.',f,Zb2bil1,'b',f,Zb2bil2,'b--',f,Zb2bil3,'b-.');
legend('unloaded 1','unloaded 2','unloaded 3','loaded 1','loaded 2','loaded 3');
xlabel('Frequency(Hz)');
ylabel('Impeadance Magnitude(Ohm)');
title('back to back with interface magnitude plot');

figure
semilogx(f,Phb2bi1,'r',f,Phb2bi2,'r--',f,Phb2bi3,'r-.',f,Phb2bil1,'b',f,Phb2bil2,'b--',f,Phb2bil3,'b-.');
legend('unloaded 1','unloaded 2','unloaded 3','loaded 1','loaded 2','loaded 3');
xlabel('Frequency(Hz)');
ylabel('Impeadance Phase(deg)');
title('back to back with interface phase plot');
%% face to back 
figure
semilogx(f,Zf2b1,'r',f,Zf2b2,'r--',f,Zf2b3,'r-.',f,Zf2bl1,'b',f,Zf2bl2,'b--',f,Zf2bl3,'b-.');
legend('unloaded 1','unloaded 2','unloaded 3','loaded 1','loaded 2','loaded 3');
xlabel('Frequency(Hz)');
ylabel('Impeadance Magnitude(Ohm)');
title('face to back magnitude plot');

figure
semilogx(f,Phf2b1,'r',f,Phf2b2,'r--',f,Phf2b3,'r-.',f,Phf2bl1,'b',f,Phf2bl2,'b--',f,Phf2bl3,'b-.');
legend('unloaded 1','unloaded 2','unloaded 3','loaded 1','loaded 2','loaded 3');
xlabel('Frequency(Hz)');
ylabel('Impeadance Phase(deg)');
title('face to back phase plot');
%% face to back with interface
figure
semilogx(f,Zf2bi1,'r',f,Zf2bi2,'r--',f,Zf2bi3,'r-.',f,Zf2bil1,'b',f,Zf2bil2,'b--',f,Zf2bil3,'b-.');
legend('unloaded 1','unloaded 2','unloaded 3','loaded 1','loaded 2','loaded 3');
xlabel('Frequency(Hz)');
ylabel('Impeadance Magnitude(Ohm)');
title('face to back with interface magnitude plot');

figure
semilogx(f,Phf2bi1,'r',f,Phf2bi2,'r--',f,Phf2bi3,'r-.',f,Phf2bil1,'b',f,Phf2bil2,'b--',f,Phf2bil3,'b-.');
legend('unloaded 1','unloaded 2','unloaded 3','loaded 1','loaded 2','loaded 3');
xlabel('Frequency(Hz)');
ylabel('Impeadance Phase(deg)');
title('face to back with interface phase plot');
%% face to face 
figure
semilogx(f,Zf2f1,'r',f,Zf2f2,'r--',f,Zf2f3,'r-.',f,Zf2fl1,'b',f,Zf2fl2,'b--',f,Zf2fl3,'b-.');
legend('unloaded 1','unloaded 2','unloaded 3','loaded 1','loaded 2','loaded 3');
xlabel('Frequency(Hz)');
ylabel('Impeadance Magnitude(Ohm)');
title('face to face magnitude plot');

figure
semilogx(f,Phf2f1,'r',f,Phf2f2,'r--',f,Phf2f3,'r-.',f,Phf2fl1,'b',f,Phf2fl2,'b--',f,Phf2fl3,'b-.');
legend('unloaded 1','unloaded 2','unloaded 3','loaded 1','loaded 2','loaded 3');
xlabel('Frequency(Hz)');
ylabel('Impeadance Phase(deg)');
title('face to face phase plot');
%% face to face with interface
figure
semilogx(f,Zf2fi1,'r',f,Zf2fi2,'r--',f,Zf2fi3,'r-.',f,Zf2fil1,'b',f,Zf2fil2,'b--',f,Zf2fil3,'b-.');
legend('unloaded 1','unloaded 2','unloaded 3','loaded 1','loaded 2','loaded 3');
xlabel('Frequency(Hz)');
ylabel('Impeadance Magnitude(Ohm)');
title('face to face with interface magnitude plot');

figure
semilogx(f,Phf2fi1,'r',f,Phf2fi2,'r--',f,Phf2fi3,'r-.',f,Phf2fil1,'b',f,Phf2fil2,'b--',f,Phf2fil3,'b-.');
legend('unloaded 1','unloaded 2','unloaded 3','loaded 1','loaded 2','loaded 3');
xlabel('Frequency(Hz)');
ylabel('Impeadance Phase(deg)');
title('face to face with interface phase plot');