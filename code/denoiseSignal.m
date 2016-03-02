function [ denoisedSignal ] = denoiseSignal( noisySignal, noiseFrequency )
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
% thr = thselect(noisySignal,'heursure');
% thr = thselect(signal,'minimaxi');
% 'rigrsure'	- Selection using principle of Stein's Unbiased Risk Estimate (SURE)
% 'sqtwolog'	-   Fixed form (universal) threshold equal to ..... with N the length of the signal.
% 'heursure'	-   Selection using a mixture of the first two options
% 'minimaxi'	-   Selection using minimax principle
% scal = 'sln'; % Use model assuming standard Gaussian white noise.
% l = wmaxlev(length((noisySignal)), 'sym6');
% denoisedSignal = wden((noisySignal), 'rigrsure', 'h', scal, l, 'sym10');
% denoisedSignal = cmddenoise(noisySignal, 'db15',l);
% denoisedSignal = cmddenoise(noisySignal, 'sym6',l,'s',6);

% Butterworth filtering !!
cuttof = 2;
Wn = noiseFrequency/(3*10)
% Wn = cuttof/(1000/2)
[b,a]  = butter(2, Wn, 'low');
denoisedSignal = filtfilt(b,a,noisySignal);
end

