function speed = speedByCorrelation( signal1, signal2, t, dist, delta_t)
%SPEEDBYCORRELATION Summary of this function goes here
%   Detailed explanation goes here

[c,lags]=xcorr(signal1,signal2, 'biased' );  %do the cross-correlation
figure(2);
clf(2);
plot(lags,c);
title('correlated speed');
[~,I] = max((c(:))); %find the best correlation
delay = abs(lags(I));  %here is the delay in samples
speed = 0.5*dist/(delta_t*delay)    % 0.4 = 

end

