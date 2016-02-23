function [ denoisedSignal ] = denoiseSignal( noisySignal )
%DENOISESIGNAL Summary of this function goes here
%   Detailed explanation goes here

%Soft or hard thresholding ?
% Hard thresholding can be described as setting to zero the elements whose
% absolute values are lower than the threshold -> if x>thr then x, if
% x<=thr then 0

% Soft thresholding is an extension of hard thresholding, 
% first setting to zero the elements whose absolute values 
% are lower than the threshold, and then shrinking the 
% nonzero coefficients towards 0. 
% The soft threshold signal is sign(x)(x-thr) if x>thr and is 0 if x<=thr.

% soft generally better
% thr = thselect(signal,'rigrsure');
% thr = thselect(signal,'sqtwolog');
thr = thselect(noisySignal,'heursure')
% thr = thselect(signal,'minimaxi');

scal = 'one'; % Use model assuming standard Gaussian white noise.
l = wmaxlev(length(noisySignal), 'db12')
denoisedSignal = wden(noisySignal, 'heursure', 's', scal, l, 'db12');

end

