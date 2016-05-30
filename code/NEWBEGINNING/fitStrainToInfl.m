function [ beforeIndex, afterIndex, strainSignal ] = fitStrainToInfl( strainSignal, inflMat, averaged, C, before, after )
%FITSTRAINTOINFL Summary of this function goes here
%   Detailed explanation goes here

% smooth signal to find proper peaks
filtered = fftFilter(strainSignal, 1, length(strainSignal), 5, 1024, 1:length(strainSignal));
% filtered =  denoiseSignal( strainSignal, 20 );
% Find the peaks of signal
d1 = diff(filtered);
temp = d1;
temp(temp<0) = 0;
filteredPositive = temp;
minPeakHeight = max(filtered)/3;
[pks, locs] = findpeaks(filtered, 'MinPeakHeight', minPeakHeight);
% C_new = zeros(1, length(locs));
for i = 2:length(locs)
    C_new(i) = locs(i)- locs(1);
end
locs(1) = round(locs(1)-C(2)/2);
% locs(1) = round(locs(1)-C(2)/2);
% locs = [locs; round(locs(1)+C(2))];
figure(13)
plot(1:length(strainSignal), filtered, locs, filtered(locs), 'o')
title('Strain signal');
legend('filtered strain signal', 'peaks from findpeaks');
xlabel('sensor samples');
% ylabel('\varepsilon');
% matlab2tikz('..\..\thesis\tikz\strains\axlePeaks.tex', 'height', '\textwidt', 'width', '\textwidth');

if locs(1)-before < 1
    num_extra_samples = before - (locs(1));
    newVec = zeros(num_extra_samples, 1);
    strainSignal = [newVec; strainSignal];
    filtered = [newVec; filtered];
    beforeIndex = 1;
else
    beforeIndex = (locs(1))-before;
end
if (beforeIndex + length(inflMat(:,1))-1)> length(strainSignal)
%     need to either shorten the influence line or elongate the strain
%     signal, i think appending zeros to strain signal will be the best
%     solution although it shouldnt really matter..
    num_extra_samples = (beforeIndex + length(inflMat(:,1))-1) - length(strainSignal);
    strainSignal = [strainSignal ; zeros(num_extra_samples, 1)];
    filtered = [filtered ; zeros(num_extra_samples, 1)];
    afterIndex = length(strainSignal);
else
    afterIndex = beforeIndex + length(inflMat(:,1))-1;
end

signal = filtered(beforeIndex:afterIndex);
locs = locs - beforeIndex;
% locs(1) = locs(1)+round(C(2)/2);
% locs(1) = locs(1)+round(C(3));
figure(14)
plot(1:length(signal), signal, 1:length(strainSignal(beforeIndex:afterIndex)), strainSignal(beforeIndex:afterIndex), locs, signal(locs), 'gx', 1:length(inflMat(:,1)), inflMat(:,1)*10000, 'm--', 1:length(inflMat(:,2)), inflMat(:,2)*10000, 'm--', 1:length(inflMat(:,3)), inflMat(:,3)*10000,'m--', 1:length(inflMat(:,4)), inflMat(:,4)*10000, 'm--', 1:length(inflMat(:,5)), inflMat(:,5)*10000, 'm--', 1:length(inflMat(:,6)), inflMat(:,6)*10000, 'm--', 1:length(inflMat(:,7)), inflMat(:,7)*10000, 'm--', 1:length(inflMat(:,8)), inflMat(:,8)*10000, 'm--', locs, signal(locs), 'gx', 'MarkerSize', 10)
% plot(1:length(signal), signal, 1:length(strainSignal(beforeIndex:afterIndex)), strainSignal(beforeIndex:afterIndex), locs, signal(locs), 'gx', 1:length(inflMat(:,1)), inflMat(:,1)*10000, 'm--', 1:length(inflMat(:,2)), inflMat(:,2)*10000, 'm--', 1:length(inflMat(:,3)), inflMat(:,3)*10000,'m--', 1:length(inflMat(:,4)), inflMat(:,4)*10000, 'm--', 1:length(inflMat(:,5)), inflMat(:,5)*10000, 'm--', 1:length(inflMat(:,6)), inflMat(:,6)*10000, 'm--', locs, signal(locs), 'gx', 'MarkerSize', 10)

legend('filtered', 'unfiltered', 'bogie position', 'influence lines')
% cleanfigure();
% % strainSignal = strainSignal(startStrain:endStrain);
% % A = (inflMat\strainSignal);
% fileNameString = ['..\..\thesis\tikz\influenceLines\placementOfInfluenceLines.tex' ];
% matlab2tikz(fileNameString, 'height', '\textwidt', 'width', '\textwidth');

end

