function speed = speedByCorrelation( signal1, signal2, t, dist, delta_t)
%SPEEDBYCORRELATION Summary of this function goes here
%   Detailed explanation goes here

% The cross-correlation of the two measurements is maximum at a lag equal to the delay.
s1 = (signal1 - mean(signal1)) / std(signal1);
s2 = (signal2 - mean(signal2)) / std(signal2);
[c,lags]=xcorr(signal1,signal2,'unbiased');  %do the cross-correlation
[~,I] = max((c)); %find the best correlation
delay = abs(lags(I))  %here is the delay in samples
D = finddelay(s1,s2)

    speed = dist*delta_t/(delay) ;%/2.316602316602317) OR SOME CONSTANT BASED ON SYSTEM SETUP
% phdiff = phdiffmeasure(s1,s2)


% speed = 1;
end

