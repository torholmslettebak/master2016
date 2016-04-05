function [ denoisedSignal ] = denoiseSignal( noisySignal, noiseFrequency )
%DENOISESIGNAL This function takes a noisy signal and filters out noise

% Butterworth filtering !!
cutoff = noiseFrequency/6; % Cutoff frequency
f = 1024;   % Sampling frequency
Wn = cutoff/(f/2);
% Wn = cuttof/(1000/2)
[b,a]  = butter(2, Wn, 'low');
denoisedSignal = filtfilt(b,a,noisySignal);
end

