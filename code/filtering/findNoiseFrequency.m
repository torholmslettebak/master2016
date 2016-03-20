function [ frequency ] = findNoiseFrequency( strainHist, samplingFrequency)
% Supposed to find the frequency of noise in a signal
[maxValue, indexMax] = max(abs(fft(strainHist-mean(strainHist))));
frequency = indexMax * samplingFrequency / length(strainHist);
end

