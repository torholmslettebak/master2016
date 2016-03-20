function [ inflMat, infl] = buildInflMatOptimization( strainHistory, TrainData, sensorLoc,h )
%BUILDINFLMATOPTIMIZATION This function should build an influence line
%based on the values given in h, which hold magnitude for different
%positions on the influence line.
% disp('the h vector ');

%   Detailed explanation goes here
% L_a = 0;
% if(sensornum==1)

% else
%     L_a = SensorData.sensorB_loc;
% end
% disp(['sensorloc = ' num2str(sensorLoc)])
delta = (TrainData.bridge_L+sum(TrainData.axleDistances))/(length(strainHistory));
x1 = 0:delta:sensorLoc;
x2 = sensorLoc:delta:TrainData.bridge_L;
x = [x1,x2(2:length(x2))];
if length(h)==1
    disp(sensorLoc);
    infl1 = (h/sensorLoc)*x1;
    infl2 = h - (h/sensorLoc)*(x2-sensorLoc);
    infl = [infl1, infl2];
    
elseif length(h)>1 
    h = [h 0];
    % The distance between data points
%     dist = (length(x)/(length(h)));
    if sensorLoc <= x(length(x))/2 
        dist1 = round(length(x1)/(round(length(h)/2)))
        dist2 = round(length(x2)/floor((length(h)/2)))
    else
        dist1 = round(length(x1)/(floor(length(h)/2)))
        dist2 = round(length(x2)/round((length(h)/2)))
    end
%     infl1(1:round(dist1)) = (h(1)/x(round(dist1)))*x1(1:round(dist1));
%     infl2(1:round(dist2)) = (h((length(h)/2)+1)/x(round(dist2)))*x2(1:round(dist2));
%     index = dist1;
    length(x)
%     for i = 2:length(h)
%         disp(['current index is' num2str(index) ' the total length of x is: ' num2str(length(x)) ' length x1 = ' num2str(length(x1)) ' length x2 = ' num2str(length(x2))]);
%         if x(index) < sensorLoc
%             
%             infl1(round(index):round(index+dist1)) = h(i-1) + (((h(i)-h(i-1))/x(round(dist1))))*(x(round(index):round(index+dist1))-x(round(dist1)*(i-1)));
%             index = index + dist1;
%         elseif x(index) > sensorLoc
%             index = dist2;
%             infl2(round(index):round(index+dist2)) = h(i-1) + (((h(i)-h(i-1))/x(round(dist2))))*(x2(round(index):round(index+dist2))-x(round(dist2)*(i-1)));
%             index = index + dist2;
% % %             y = ax + b
% %             a = (h(i)-h(i-1))/x(round(dist));
% %             b = (h(i-1));
% %             infl(round(index):round(index+dist)) = a*(x(round(index):round(index+dist))-x(round(dist)*(i-1)))+ b;
%            
%         end
        
%     end
    index = dist1;
    counter = 1;
    infl1(1:round(dist1)) = (h(1)/x(round(dist1)))*x1(1:round(dist1));
    for i = 2:round(length(h)/2)
        disp(['i = ' num2str(i)])
        disp(['h(i-1) = ' num2str(h(i-1))])
        a = (((h(i)-h(i-1))/x(round(dist1))))
        x(round(dist1)*counter)
        b = h(i-1)
        
        infl1(index:index+dist1) = b + a*(x1(round(index):round(index+dist1))-x1(round(dist1)*counter));
        
        index = index+dist1;
        counter = counter + 1;
    end
    disp('first done');
    index = dist2;
    h(round(length(h)/2)+1)
    (h(round(length(h)/2)+1) - h(round(length(h)/2)))/x(round(dist2))
    infl2(1:round(dist2)) = infl1(length(infl1)) + ((h(round(length(h)/2)+1) - h(round(length(h)/2)))/x(round(dist2)))*(x2(1:round(dist2))-sensorLoc);
    counter = 1;
    for j = round(length(h)/2)+2:length(h)
        disp(['j = ' num2str(j)])
        disp(['h(j) = ' num2str(h(j))])
        disp(['h(j-1) = ' num2str(h(j-1))])
        a = (((h(j)-h(j-1))/x(round(dist2))))
        infl2(length(infl2))
        disp(['index = ' num2str(index) ' index + dist2 = ' num2str(index + dist2)])
        infl2(index:(index+dist2)) = h(j-1) + a*(x2(index:(index+dist2)) - (sensorLoc + x(dist2)*counter));        
        
        index = index+dist2;
        counter = counter+1;
    end
    infl = [infl1 infl2(2:length(infl2))];
else
    disp('Not enough parameters');
    return;
end
C = axleDistancesInSamples(TrainData);
inflMat = genInflMatFromCalcInflLine(infl, TrainData.axles, C);

% size(inflMat);
% length(x)
% length(infl)
% clf(8)
plot(x,infl)
hold on;
end

