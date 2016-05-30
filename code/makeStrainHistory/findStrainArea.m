function [ startIndex, endIndex, M ] = findStrainArea( M, trainFile )
%FINDSTRAINAREA Supposed to remove all unessential parts of the strain
%history. Will also set initial y value to zero..
addpath('..\filtering');
startIndex = inf;
endIndex = 0;
indexes = zeros(2,3);
for col = 2:length(M(1,:))
    raw_strain = M(:,col);
%     filteredStrain = fftFilter(raw_strain, 1, length(raw_strain), 5, 1024, 1:length(raw_strain));
    filteredStrain = denoiseSignal(raw_strain, 20);
    filteredStrain = shiftVectorToZero(filteredStrain);
    shiftedRaw = shiftVectorToZero(raw_strain);
    temp = filteredStrain;
    temp(temp<0) = 0;
    neg_zero = temp;
    if trainFile==7
        [pks1, locs1] = findpeaks(neg_zero,'NPeaks',1, 'MinPeakHeight', max(neg_zero)/10);   
        testingLocs = [max(locs1)+250 min(locs1)-600];
    else
        [pks1, locs1] = findpeaks(neg_zero,'SortStr','descend','NPeaks',4);  
        testingLocs = [max(locs1)+600 min(locs1)-600];
%     first = min(locs1) - round(min(locs1)/7);
%     last = max(locs1) + round((length(raw_strain)-max(locs1))/7);
    end
%     testingLocs = [max(locs1)+600 min(locs1)-600];
%     temp = filteredStrain;
%     temp(temp>0) = 0;
%     pos_zero = temp;
%     [pks2, locs2] = findpeaks(abs(pos_zero(first:last)),'SortStr','descend','NPeaks',4);
%     locs = [locs1; locs2+first];
% %     figure(2);
% %     plot(1:length(filteredStrain), filteredStrain, locs, filteredStrain(locs), 'o')
%     
%     first2 = min(locs) - round(min(locs)/10);
%     last2 = max(locs) + round((length(raw_strain)-max(locs))/10);
%     derivated = diff(filteredStrain(first2:last2));
% %     derivated = diff(derivated);
%     temp = derivated;
%     temp(temp<0) = 0;
%     neg_zero = temp;
%     [pks1, locs1] = findpeaks(neg_zero,'SortStr','descend','NPeaks',10); %, 'MinPeakHeight', max(neg_zero)/10
%     
%     temp = derivated;
%     temp(temp>0) = 0;
%     pos_zero = temp;
%     [pks2, locs2] = findpeaks(abs(pos_zero),'SortStr','descend','NPeaks',10);
%     locssecond = [locs1+first2; locs2+first2];
% %     figure(3)
% %     plot(1:length(filteredStrain), filteredStrain, locssecond, filteredStrain(locssecond), 'o');
% %     close(3);
%     
%     %     raw_strain = f
% %     filteredStrain = denoiseSignal(raw_strain, 10);
% %     filteredStrain = shiftVectorToZero(filteredStrain);
% %     temp = filteredStrain;
% %     temp(temp>=0) = 0;
% %     filteredNegative = temp;
% %     temp = filteredStrain;
% %     temp(temp<0) = 0;
% %     filteredPositive = temp;
% %     [pks2, locs2] = findpeaks(abs(filteredNegative), 'MinPeakHeight', max(abs(filteredNegative))/10);
% %     figure(3);
% %     plot(1:length(filteredStrain), filteredStrain, locs2, filteredStrain(locs2), 'o')
% %     figure(4)
% %     [pks2, locs2] = findpeaks(abs(filteredNegative), 'MinPeakHeight', max(abs(filteredPositive))/10);
% %     plot(1:length(filteredStrain), filteredStrain, locs2, filteredStrain(locs2), 'o')
% 
% %         d1 = diff(filteredStrain);
% %     temp = d1;
% %     temp(temp<0) = 0;
% %     filteredPositive = temp;
% %     minPeakHeight = max(filteredPositive)/10;
% %     [pks, locs] = findpeaks(filteredPositive, 'MinPeakHeight', minPeakHeight);
% %     temp = d1;
% %     temp(temp>0) = 0;
% %     filteredNegative = temp;
% %     test2 = mean(filteredNegative);
% %     minPeakHeight = min(filteredNegative)/10;
% %     [pks2, locs2] = findpeaks(-filteredNegative, 'MinPeakHeight',-minPeakHeight);
% %     peakLocs = [locs ;locs2];
% %     minLoc = min(peakLocs);
% %     figure(3)
% %     plot((1:length(d1)), d1);
% %     % legend('selected', 'whole');
% %     figure(4)
% %     plot(1:length(filteredStrain), filteredStrain, locs, filteredStrain(locs), 'o')
% % %     Finding the next time line passes or equals zero
% %     i = minLoc;
% %     zeroNotFound = 1;
% %     while zeroNotFound == 1
% %         if d1(minLoc) > 0 && (d1(i) <= 0)
% %             beginning = i;
% %             zeroNotFound = 0;
% %         elseif d1(minLoc) < 0 && (d1(i) >= 0)
% %             beginning = i;
% %             zeroNotFound = 0;
% %         else
% %             i = i-1;
% %         end
% %     end
% %     % Finding the next time line passes or equals zero
% %     maxLoc = max(peakLocs);
% %     i = maxLoc;
% %     zeroNotFound = 1;
% %     while zeroNotFound==1
% %         if d1(maxLoc) > 0 && (d1(i) <= 0)
% %             ending = i;
% %             zeroNotFound = 0;
% %         elseif d1(maxLoc) < 0 && (d1(i) >= 0)
% %             ending = i;
% %             zeroNotFound = 0;
% %         else
% %             i = i+1;
% %         end
% %     end
% %     if(beginning<startIndex)
% %         startIndex = beginning + 1;
% %     end
% %     if(ending > endIndex)
% %         endIndex = ending + 1;
% %     end
% % end
% % figure(2)
% % plot(t(beginning:ending), d1(beginning:ending), '.', t(1:length(d1)), d1);
% % legend('selected', 'whole');
% 
% % account for locations obtained by derivatives.. diff reduces number of
% % indexes by 1
% % beginning = beginning + 1;
% % ending = ending + 1;
% % strain = raw_strain(beginning:ending);
% locssecond = [locssecond; locs];
% startIndex = min(locssecond);
% endIndex = max(locssecond);
startIndex = min(testingLocs);
endIndex = max(testingLocs);
indexes(1,col-1) = startIndex;
indexes(2,col-1) = endIndex;
% figure(3)
% plot(1:length(filteredStrain), shiftedRaw, startIndex, shiftedRaw(startIndex), 'o', endIndex, shiftedRaw(endIndex), 'o', 'MarkerSize', 10);
% close(3)
end
if trainFile == 7
   startIndex = indexes(1,2);
   endIndex = indexes(2,2);
   raw_strain = shiftVectorToZero(M(:,3));
   %     filteredStrain = fftFilter(raw_strain, 1, length(raw_strain), 5, 1024, 1:length(raw_strain));
   filteredStrain = denoiseSignal(raw_strain, 20);
   filteredStrain = shiftVectorToZero(filteredStrain);
   figure(4)
   plot(1000:4300, raw_strain(1000:4300),startIndex, raw_strain(startIndex), 'ro', endIndex, raw_strain(endIndex), 'ro', 'MarkerSize', 10);
   title('Extracting locomotive from sensor data')
   xlabel('sample points')
   ylabel('strain')
   legend('raw strain', 'first cutting point', 'first bogie over')
%    fileNameString = ['..\..\thesis\tikz\calibration.tex' ];
%    matlab2tikz(fileNameString, 'height', '\figureheight', 'width', '\figurewidth');

   close(4)
end
end

