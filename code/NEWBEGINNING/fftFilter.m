function [ remade ] = fftFilter( vector, start, ending, frequencyToRemove, samplingFrequency, xvec )
%FINDFREQUENCY Summary of this function goes here
%   Detailed explanation goes here

NFFT = length(vector);
y1 = fft(vector,NFFT);
Fs = samplingFrequency;
F = ((0:1/NFFT:1-1/NFFT)*Fs).';
magnitudeY = abs(y1);        % Magnitude of the FFT
phaseY = unwrap(angle(y1));  % Phase of the FFT
Ylp = y1;
Ylp(F>frequencyToRemove) = 0;
remade = ifft(Ylp, NFFT, 'symmetric');
% figure(22)
% plot(xvec, remade, xvec, vector);
% legend('filtered avg, 10 hz', 'original');
% % title('filtered average, short signal')
% xlabel('x [m]');
% ylabel('magnitude')
% matlab2tikz('..\..\thesis\tikz\influenceLines\infl_vec_averaged_fft10hz.tex', 'height', '\textwidt', 'width', '\textwidth');
% close(22)
% p = polyfit(xvec,transpose(vector),7)
% ytest=  polyval(p,xvec);
% plot(xvec,ytest);

end

