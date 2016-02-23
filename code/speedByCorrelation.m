function speed = speedByCorrelation( signal1, signal2, t, dist, delta_t)
%SPEEDBYCORRELATION Summary of this function goes here
%   Detailed explanation goes here

[c,lags]=xcorr(signal1,signal2, 'biased' );  %do the cross-correlation

clf(4);
plot(lags,c);
[~,I] = max((c(:))); %find the best correlation
delay = abs(lags(I))  %here is the delay in samples
speed = 0.4*dist/(delta_t*delay)    % 0.4 = 

end

