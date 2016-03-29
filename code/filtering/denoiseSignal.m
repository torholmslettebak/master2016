function [ denoisedSignal ] = denoiseSignal( noisySignal, noiseFrequency )
%DENOISESIGNAL This function takes a noisy signal and filters out noise

% Butterworth filtering !!
cuttof = 2;
Wn = (noiseFrequency);
% Wn = cuttof/(1000/2)
[b,a]  = butter(2, Wn, 'low');
denoisedSignal = filtfilt(b,a,noisySignal);
end

