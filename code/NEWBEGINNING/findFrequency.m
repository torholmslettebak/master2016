function [ frequency ] = findFrequency( vector, start, ending )
%FINDFREQUENCY Summary of this function goes here
%   Detailed explanation goes here
Y = fft(vector(start:ending));
P2 = abs(Y/ending);
P1 = P2(1:ending/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = 1024*(0:(ending/2))/ending;
figure(14)
plot(f, P1)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
close(14)
[maxVal, Ind] = max(P1)
frequency = [maxVal Ind]
end

