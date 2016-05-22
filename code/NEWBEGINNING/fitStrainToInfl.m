function [ beforeIndex, afterIndex ] = fitStrainToInfl( strainSignal, inflMat, averaged, C, before, after )
%FITSTRAINTOINFL Summary of this function goes here
%   Detailed explanation goes here

% smooth signal to find proper peaks
filtered = fftFilter(strainSignal, 1, length(strainSignal), 17, 1024, 1:length(strainSignal)); 
% Find the peaks of signal
d1 = diff(filtered);
temp = d1;
temp(temp<0) = 0;
filteredPositive = temp;
minPeakHeight = max(filtered)/10;
[pks, locs] = findpeaks(filtered, 'MinPeakHeight', minPeakHeight);
figure(13)
plot(1:length(strainSignal), filtered, locs, filtered(locs), 'o')
title('Strain signal');
legend('filtered strain signal', 'peaks from findpeaks');
xlabel('sensor samples');
ylabel('\varepsilon');
matlab2tikz('..\..\thesis\tikz\strains\axlePeaks.tex', 'height', '\textwidt', 'width', '\textwidth');
close(13);
beforeIndex = locs(1)-before;
afterIndex = beforeIndex + length(inflMat(:,1))-1;
end

