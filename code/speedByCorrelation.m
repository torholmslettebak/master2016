function speed = speedByCorrelation( signal1, signal2, t, dist, delta_t)
%SPEEDBYCORRELATION Summary of this function goes here
%   Detailed explanation goes here

% figure; hold on; plot(t,signal1); plot(t,signal2)

% The cross-correlation of the two measurements is maximum at a lag equal to the delay.
% s1 = (signal1 - mean(signal1)) / std(signal1);
% s2 = (signal2 - mean(signal2)) / std(signal2);
%signal2 = signal1;
%signal2(1:end-1) = signal1(2:end);
[c,lags]=xcorr(signal1,signal2);  %do the cross-correlation
%figure; plot(lags,c)
[~,I] = max((c)); %find the best correlation
delay = abs(lags(I))  %here is the delay in samples

%D = finddelay(s1,s2)

    %speed = dist*delta_t/(delay) ;%/2.316602316602317) OR SOME CONSTANT BASED ON SYSTEM SETUP
    speed = dist/(delta_t*delay)
%speed
% phdiff = phdiffmeasure(s1,s2)
y = zeros(length(t));

% for p = 1:length(t)
%     val = 0;
%     for i = 1:length(t)-p
%         val =  val + (1/(length(t)-p))*signal1(i)*signal2(i+1);
%     end
%     y(p) = val;
% end
% [~, index] = max(y(:));
% disp([' max value at p =  ' num2str(index)]);
% disp(['calculated speed by dist/(index*delta_t) = ' num2str(dist/(index*delta_t))]);
% dist/(index*delta_t)
figure(6);
clf(6);
plot(1:length(y), y);
% speed = 1;
end

