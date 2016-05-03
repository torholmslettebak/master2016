function [ infl ] = buildLinearInfluenceLine( x, x1,x2, h, sensorLoc)
%BUILDLINEARINFLUENCELINE Summary of this function goes here
%   Detailed explanation goes here
if length(h)==1
    disp(sensorLoc);
    infl1 = (h/sensorLoc)*x1;
    infl2 = h - (h/sensorLoc)*(x2-sensorLoc);
    infl = [infl1, infl2];
    
elseif length(h)>1 
%     h = [h 0];
    hSplitArr = splitArray(length(h), 2);
    interValsX1 = splitArray(length(x1), hSplitArr(1));
    index = 1;
    for i = 1:hSplitArr(1)
        if i == 1
            b = 0;
            a = (h(i))/x(interValsX1(i));
        else
            b = h(i-1);
            a = (h(i) - h(i-1))/x(interValsX1(i));
        end
        infl1(index:index + interValsX1(i)-1) = b + a*(x1(index:interValsX1(i)+index-1) - x1(index));
        index = index+interValsX1(i);
    end
    
    interValsX2 = splitArray(length(x2), hSplitArr(2));
    index = 1;
    h2 = h(hSplitArr(1)+1:length(h));
    for j = 1:hSplitArr(2)
        if j == 1
            b = h(hSplitArr(1));
            a = (h2(j) - h(hSplitArr(1)))/x(interValsX2(j));
        else
            b = h2(j-1);
            a = (h2(j) - h2(j-1))/x(interValsX2(j));
        end
        xVals = (x2(index:interValsX2(j)+index-1) - x2(index));
        infl2(index:index + interValsX2(j)-1) = b + a*xVals;
        index = index+interValsX2(j);
    end
    infl = [infl1 infl2];
else
    disp('Not enough parameters');
    return;
end

