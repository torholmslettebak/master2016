function [ noise ] = bridgeWithoutTrain( time )
%BRIDGEWITHOUTTRAIN Summary of this function goes here
%   Detailed explanation goes here
signal = zeros(1,length(time));
noise = awgn(signal, 100);
figure(5);
clf(5)
plot(time, noise);

end

