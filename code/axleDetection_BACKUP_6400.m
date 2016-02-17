function [ axledist ] = axleDetection( strainHist, t, speed)
% Detects each axle, and finds the distance between them
% Axles can be found through the peaks of the strain curve
% two derivations of the strain curve will find the absolute value of the
% peaks

firstDerivative = diff(strainHist);
x1 = 0:length(firstDerivative)-1;
secondDerivative = -1* (diff(firstDerivative));
thirdDeriv = abs(diff(((secondDerivative))));
x2 = 0:length(secondDerivative)-1;
<<<<<<< HEAD
[pks, locs, w, p] = findpeaks((secondDerivative),'MinPeakProminence',0.00000000000001); 
=======
x3 = 0:length(thirdDeriv)-1;
filterVal = max((thirdDeriv));
[pks, locs, w, p] = findpeaks((abs(thirdDeriv)),'MinPeakHeight', filterVal-(filterVal/1000)); 

% [pks, locs] = max(secondDerivative(:));
disp(pks)
disp(locs)

% [pks, locs, w, p] = findpeaks(abs(secondDerivative)); 
>>>>>>> 4cc1e5e1d41c6b7ca19b2b57816f498d064b72ca
%MINPEAKPROMINENCE should be based on input weights.. 
%if weights arent large enough peaks will not be accommodated for

figure(3)
clf(3)
<<<<<<< HEAD
plot(t(1:length(t)-1), firstDerivative, t(1:length(t)-2), secondDerivative)
=======
plot(x1, firstDerivative, x2, (secondDerivative), x3, thirdDeriv)
>>>>>>> 4cc1e5e1d41c6b7ca19b2b57816f498d064b72ca
hold on
% plot()
title('Derivations of strain history');
xlabel('index of strain history');
ylabel('derivative value');
legend('First Derivative', 'Second Derivative')
% disp('max2')
% disp(pks)
% disp('index2')
% disp(locs)
% disp('p')
% disp(p)
<<<<<<< HEAD

disp('time between axles')
disp( t(locs(2)+2)); 
disp( t(locs(1)+2));
axledist = speed * ((t(locs(2)+2) - (t(locs(1)+2  ))));
=======
disp(['number of peaks: ' num2str(length(pks))])
% pks
if(length(pks) > 0)
    axleDistances = [];
    
%     disp('time between axles')
%     disp( t(locs(2)+2));
%     disp( t(locs(1)+2));
    axledist = speed * ((t(locs(2)+2) - (t(locs(1)+2    ))));
    for i = 1:length(pks)-1
        axleDistances(i) = speed * ( t(locs(i+1)+2) - t(locs(i)+2) );
        
    end
    axleDistances
>>>>>>> 4cc1e5e1d41c6b7ca19b2b57816f498d064b72ca
end

