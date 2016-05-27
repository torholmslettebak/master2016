function [ startIndex, endIndex, M ] = findStrainArea2( M )
%FINDSTRAINAREA Supposed to remove all unessential parts of the strain
%history. Will also set initial y value to zero..
addpath('..\filtering');
startIndex = inf;
endIndex = 0;
for col = 2:length(M(1,:))
    raw_strain = M(:,col);
    filteredStrain = denoiseSignal(raw_strain, 20);
    d1 = diff(filteredStrain);
    temp = d1;
    temp(temp<0) = 0;
    filteredPositive = temp;
    minPeakHeight = max(filteredPositive)/10;
    [pks, locs] = findpeaks(filteredPositive, 'MinPeakHeight', minPeakHeight);
    temp = d1;
    temp(temp>0) = 0;
    filteredNegative = temp;
    test2 = mean(filteredNegative);
    minPeakHeight = min(filteredNegative)/10;
    [pks2, locs2] = findpeaks(-filteredNegative, 'MinPeakHeight',-minPeakHeight);
    peakLocs = [locs ;locs2];
    minLoc = min(peakLocs);
%     figure(2)
%     plot(t(1:length(d1)), d1);
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
    if(beginning<startIndex)
        startIndex = beginning + 1;
    end
    if(ending > endIndex)
        endIndex = ending + 1;
    end
end
% figure(2)
% plot(t(beginning:ending), d1(beginning:ending), '.', t(1:length(d1)), d1);
% legend('selected', 'whole');

% account for locations obtained by derivatives.. diff reduces number of
% indexes by 1
% beginning = beginning + 1;
% ending = ending + 1;
% strain = raw_strain(beginning:ending);

end