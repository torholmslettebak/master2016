function [ influenceLine ] = optimizeInfluenceLineALT(  strainHistory, TrainData, sensorLoc )
%OPTIMIZEINFLUENCELINEALT Summary of this function goes here
%   Detailed explanation goes here
C = axleDistancesInSamples(TrainData);
len_infl = length(strainHistory)-C(length(C));
% Finding the first peak of the strainHistory, this should give a decent
% approximation of where to put max value of the influence line
addpath('..\filtering\');
smoothedSignal = denoiseSignal(strainHistory, 20);
% figure(20)
% plot(1:length(strainHistory), smoothedSignal);
% close(20);
npeaks = round(length(TrainData.axleWeights)/2);
[pks, locs] = findpeaks(smoothedSignal,'SortStr','descend', 'NPeaks', npeaks);
[minimum, loc] = min(locs);
indexArray = 1:length(strainHistory);
test = indexArray(indexArray<=minimum);
part1 = exp(test*0.05);
part2 = fliplr(part1(1:length(part1)-1));
initialGuess = zeros(1, len_infl);
initialGuess(1:length([part1 part2])) = [part1 part2];
scale = findScale(initialGuess, 1e-8);
indices1 = 1:200:minimum;
indices2 = minimum:200:len_infl;
indexVec = [indices1 indices2];
h1 = initialGuess(indexVec)*scale;
% figure(40);
% plot(1:length(initialGuess), initialGuess);
% % close(35);
type = 'test';
inflMat = @(h)(buildInflMatOptimization( strainHistory, TrainData, sensorLoc, h, type, indexVec, [], [],[]));
% inflMat = @(h) genInflMatFromCalcInflLine(h, TrainData.axles, C);
% inflMat = @(h)(buildInflMatOptimization( strainHistory, TrainData, sensorLoc, h, type, indexVec, x, x1, x2));
% CONSTRAINTS OF FMINCON
A = [];
b = [];
Aeq = [];
beq = [];
lb = -(1e-7)*ones(1, length(h1));
a = (1e-7 - 1e-8)/minimum;
const = 1e-8;
upperbound1 = a*indices1 + const;
const = 1e-7;
a = (1e-7 - 1e-8)/(len_infl - minimum);
upperbound2 = const - a*(indices2 - minimum);
ub = [upperbound1 upperbound2];

% ub = ones(1, length(h1));
% ub(1,minimum) = 1e-6;
% opts = optimoptions(@fmincon, 'StepTolerance', 1e-9)
options = optimoptions('fmincon', 'TolFun', 1e-9, 'TolX', 1e-12, 'TolCon', 1e-09, 'TolFun', 1e-9)
% ub(1,length(h1)) = 0;
% % % % % % % % % % % % % 
leastSquareFun = @(h)sum((strainHistory) - ((inflMat(h)*transpose(TrainData.axleWeights)))).^2;
% [h, fval] = fmincon(leastSquareFun, h1, A, b, Aeq, beq, lb, ub);
[h, fval] = fmincon(leastSquareFun, h1);
[inflmatrix] = (inflMat(h));
% figure(35)
% plot(1:length(inflmatrix(1:len_infl,1)), inflmatrix(1:len_infl,1));


% indices1 = 1:10:minimum;
% indices2 = minimum:10:len_infl;
% indexVec = [indices1 indices2];
% lb = -(1e-7)*ones(1, length(h1));
% a = (1e-7 - 1e-8)/minimum;
% const = 1e-8;
% upperbound1 = a*indices1 + const;
% const = 1e-7;
% a = (1e-7 - 1e-8)/(len_infl - minimum);
% upperbound2 = const - a*(indices2 - minimum);
% ub = [upperbound1 upperbound2];
% inflLine = inflmatrix(1:len_infl,1);
% h1 = inflLine(indexVec);
% type = 'test';
% inflMat = @(h)(buildInflMatOptimization( strainHistory, TrainData, sensorLoc, h, type, indexVec, [], [],[]));
% leastSquareFun = @(h)sum((strainHistory) - ((inflMat(h)*transpose(TrainData.axleWeights)))).^2;
% % options = optimoptions('fmincon', 'TolFun', 1e-9, 'TolX', 1e-9, 'TolCon', 1e-09, 'TolFun', 1e-9)
% [h, fval] = fmincon(leastSquareFun, h1, A, b, Aeq, beq, lb, ub);
% [inflmatrix] = (inflMat(h));
% figure(35)
% plot(1:length(inflmatrix(1:len_infl,1)), inflmatrix(1:len_infl,1));
% close(35)

influenceLine = inflmatrix(1:len_infl,1);
end

