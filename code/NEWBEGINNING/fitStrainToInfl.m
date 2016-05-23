function [ beforeIndex, afterIndex, strainSignal ] = fitStrainToInfl( strainSignal, inflMat, averaged, C, before, after )
%FITSTRAINTOINFL Summary of this function goes here
%   Detailed explanation goes here

% smooth signal to find proper peaks
filtered = fftFilter(strainSignal, 1, length(strainSignal), 7, 1024, 1:length(strainSignal));
% Find the peaks of signal
d1 = diff(filtered);
temp = d1;
temp(temp<0) = 0;
filteredPositive = temp;
minPeakHeight = max(filtered)/2;
[pks, locs] = findpeaks(filtered, 'MinPeakHeight', minPeakHeight);
% C_new = zeros(1, length(locs));
for i = 2:length(locs)
    C_new(i) = locs(i)- locs(1);
end
figure(13)
plot(1:length(strainSignal), filtered, locs, filtered(locs), 'o')
title('Strain signal');
legend('filtered strain signal', 'peaks from findpeaks');
xlabel('sensor samples');
ylabel('\varepsilon');
% matlab2tikz('..\..\thesis\tikz\strains\axlePeaks.tex', 'height', '\textwidt', 'width', '\textwidth');
close(13);
if locs(1)-before < 1
    num_extra_samples = before - locs(1);
    newVec = zeros(num_extra_samples, 1);
    strainSignal = [newVec; strainSignal];
    beforeIndex = 1;
else
    beforeIndex = locs(1)-before;
end
if (beforeIndex + length(inflMat(:,1))-1)> length(strainSignal)
%     need to either shorten the influence line or elongate the strain
%     signal, i think appending zeros to strain signal will be the best
%     solution although it shouldnt really matter..
    num_extra_samples = (beforeIndex + length(inflMat(:,1))-1) - length(strainSignal);
    strainSignal = [strainSignal ; zeros(num_extra_samples, 1)];
    afterIndex = length(strainSignal);
else
    afterIndex = beforeIndex + length(inflMat(:,1))-1;
end
end

