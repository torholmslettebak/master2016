function [axleDistances, locs ] = axleDetection( strainHist, t, speed)
% Detects each axle, and finds the distance between them
% Axles can be found through the peaks of the strain curve
% two derivations of the strain curve will find the absolute value of the
% peaks

% firstDerivative = denoiseSignal(diff(strainHist));
firstDerivative = diff(strainHist);
x1 = 0:length(firstDerivative)-1;
secondDerivative =  -1*(diff(firstDerivative));
x2 = 0:length(secondDerivative)-1;
secondDerivative(secondDerivative<mean(abs(secondDerivative))) = 0;
% thirdDerivative =  100*(diff(secondDerivative))*0;
% x3 = 0:length(thirdDerivative)-1;
filterVal = max((secondDerivative));
% [pks, locs, w, p] = findpeaks(secondDerivative,'MinPeakDistance',500, 'MinPeakHeight', mean(secondDerivative)*5);
[pks, locs, w, p] = findpeaks(((secondDerivative)), 'MinPeakHeight',mean((secondDerivative*5)));   % Alternative minPeakHeight = filterVal-(filterVal/1000)) or something
%MINPEAKPROMINENCE should be based on input weights.. 
%if weights arent large enough peaks will not be accommodated for
% disp(['length locs, pks: ' num2str(length(pks)) ' ' num2str(length(locs))]);
figure(3)
clf(3)
plot(x2, (secondDerivative), x2, (secondDerivative))
title('Derivations of strain history');
xlabel('index of strain history');
ylabel('derivative value');
legend('First Derivative', 'Second Derivative')
% disp(['number of peaks: ' num2str(length(pks))])
if(length(pks) > 0)
    axleDistances = zeros(1,length(pks)-1);
%     axledist = speed * ((t(locs(2)+2) - (t(locs(1)+2    ))));
    for i = 1:length(pks)-1
%         +2 BECAUSE derivation of strainHistory 2 times shortens the
%         vectors by 2
        axleDistances(i) = (speed * ( t(locs(i+1)+2) - t(locs(i)+2) ));
    end
end

end

