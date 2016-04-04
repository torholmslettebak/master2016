function [ strain, beginning, ending ] = findStrainArea( raw_strain, t )
%FINDSTRAINAREA Supposed to remove all unessential parts of the strain
%history. Will also set initial y value to zero..
addpath('filtering');
filteredStrain = denoiseSignal(raw_strain, 20);
d1 = diff(filteredStrain);
temp = d1;
temp(temp<0) = 0;
filteredPositive = temp;
test = mean(filteredPositive);
[pks, locs] = findpeaks(filteredPositive, 'MinPeakHeight',mean(filteredPositive)*3);
temp = d1;
temp(temp>0) = 0;
filteredNegative = temp;
test2 = mean(filteredNegative);
[pks2, locs2] = findpeaks(-filteredNegative, 'MinPeakHeight',-mean(filteredNegative)*3);
peakLocs = [locs ;locs2];
minLoc = min(peakLocs);

figure(2)
plot(t(1:length(d1)), d1);
% legend('selected', 'whole');

% Finding the next time line passes or equals zero
i = minLoc;
zeroNotFound = 1;
while zeroNotFound == 1
    if d1(minLoc) > 0 && (d1(i) <= 0)
        beginning = i;
        zeroNotFound = 0;
    elseif d1(minLoc) < 0 && (d1(i) >= 0)
        beginning = i;
        zeroNotFound = 0;
    else
        i = i-1;    
    end
end
% Finding the next time line passes or equals zero
maxLoc = max(peakLocs);
i = maxLoc;
zeroNotFound = 1;
while zeroNotFound==1
    if d1(maxLoc) > 0 && (d1(i) <= 0)
        ending = i;
        zeroNotFound = 0;
    elseif d1(maxLoc) < 0 && (d1(i) >= 0)
        ending = i;
        zeroNotFound = 0;
    else
        i = i+1;    
    end
end
% figure(2)
% plot(t(beginning:ending), d1(beginning:ending), '.', t(1:length(d1)), d1);
% legend('selected', 'whole');

% account for locations obtained by derivatives.. diff reduces number of
% indexes by 1
beginning = beginning + 1;
ending = ending + 1;
strain = raw_strain(beginning:ending);

end

