function speed = speedByCorrelation( s1, s2, t, dist)
%SPEEDBYCORRELATION Summary of this function goes here
%   Detailed explanation goes here

% The cross-correlation of the two measurements is maximum at a lag equal to the delay.
    [acor, lag] = xcorr(s2, s1);
    figure(4)
    clf(4)
    plot(lag, acor);
    [~,I] = max(abs(acor));
    D = finddelay(s1, s2)
    
    lagDiff = lag(I)
    
    disp(dist)
    speed = dist/(t(abs(lagDiff)) );%/2.316602316602317) OR SOME CONSTANT BASED ON SYSTEM SETUP

end

