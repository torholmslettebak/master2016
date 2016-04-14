function speed = speedByCorrelation( signal1, signal2, t, dist, delta_t)
%SPEEDBYCORRELATION Summary of this function goes here
%   Detailed explanation goes here

[c,lags]=xcorr(signal1,signal2, 'biased' );  %do the cross-correlation
figure(6);
plot(lags,c);
title('correlated speed');
close(6)

[~,I] = max((c(:))); %find the best correlation
delay = (lags(I));  %here is the delay in samples
speed = 0.36892*dist/(delta_t*delay)    % 0.4 = 

end

