%% back to back 
mb2b = (Zb2b1+Zb2b2+Zb2b3)./3;
mb2bl = (Zb2bl1+Zb2bl2+Zb2bl3)./3;
dmb2b = mb2bl-mb2b;
max(abs(dmb2b));
%% back to back with interface
mb2bi = (Zb2bi1+Zb2bi2+Zb2bi3)./3;
mb2bil = (Zb2bil1+Zb2bil2+Zb2bil3)./3;
dmb2bi = mb2bil-mb2bi;
max(abs(dmb2bi));
%% face to back 
mf2b = (Zf2b1+Zf2b2+Zf2b3)./3;
mf2bl = (Zf2bl1+Zf2bl2+Zf2bl3)./3;
dmf2b = mf2bl-mf2b;
max(abs(dmf2b));
%% face to back with interface
mf2bi = (Zf2bi1+Zf2bi2+Zf2bi3)./3;
mf2bil = (Zf2bil1+Zf2bil2+Zf2bil3)./3;
dmf2bi = mf2bil-mf2bi;
max(abs(dmf2bi));
%% face to face 
mf2f = (Zf2f1+Zf2f2+Zf2f3)./3;
mf2fl = (Zf2fl1+Zf2fl2+Zf2fl3)./3;
dmf2f = mf2fl-mf2f;
max(abs(dmf2f));
%% face to face with interface
mf2fi = (Zf2fi1+Zf2fi2+Zf2fi3)./3;
mf2fil = (Zf2fil1+Zf2fil2+Zf2fil3)./3;
dmf2fi = mf2fil-mf2fi;
max(abs(dmf2fi));
%% plot
semilogx(f,dmb2b,f,dmb2bi,f,dmf2b,f,dmf2bi,f,dmf2f,f,dmf2fi);
legend('back to back','back to back with interface','face to back','face to back with interface','face to face ','face to face with interface');
xlabel('Frequency(Hz)');
ylabel('Impeadance Magnitude(Ohm)');
title('magnitude difference comparison plot');
figure
semilogx(f,abs(dmb2b),f,abs(dmb2bi),f,abs(dmf2b),f,abs(dmf2bi),f,abs(dmf2f),f,abs(dmf2fi));
legend('back to back','back to back with interface','face to back','face to back with interface','face to face ','face to face with interface');
xlabel('Frequency(Hz)');
ylabel('Impeadance Magnitude(Ohm)');
title('absolute magnitude difference comparison plot');