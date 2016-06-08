clear all;

t = 0:0.1:20;
% t2 = 2:0.001:15;
phaseshift= 10;
s1 = sin(pi*t/3);
s2 = sin(pi*(t-phaseshift)/3 );  
figure(1);
plot(t, s1, t, s2)
xlabel('t (s)');
legend('sin(pi*t/3)','sin(pi*(t-phaseshift)/3')
fileNameString = '..\..\thesis\tikz\crossCorrSignals.tex'
matlab2tikz(fileNameString, 'height', '\figureheight', 'width', '\figurewidth');
Fs=10;
[acor,lag] = xcorr(s1,s2);
[~,I] = max(abs(acor));
lagDiff = lag(I)
timeDiff = lagDiff/Fs
figure(2)
plot(lag,(acor))
matlab2tikz(fileNameString, 'height', '\figureheight', 'width', '\figurewidth');