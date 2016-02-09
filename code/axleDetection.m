function [ axleDist ] = axleDetection( strainHist, t )
% Detects each axle, and finds the distance between them
% Axles can be found through the peaks of the strain curve
% two derivations of the strain curve will find the absolute value of the
% peaks
clf(4)
firstDerivative = diff(strainHist);
x1 = 0:length(firstDerivative)-1;
secondDerivative = diff(firstDerivative);
x2 = 0:length(secondDerivative)-1;
% disp(['length x = ' num2str(length(x)) ' length secondDeriv = ' num2str(length(secondDerivative))]);
figure(4)
plot(x1, firstDerivative)
hold on
plot(x2, secondDerivative)

[pks, locs, w, p] = findpeaks(secondDerivative);
disp(locs)
% plot(locs, pks);
% figure(5)
% plot(locs,pks)
test = t(locs(2)) - t(locs(1));
test
end

