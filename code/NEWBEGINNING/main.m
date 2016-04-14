
clear; clc; clf;
clear all;
addpath('..\')
addpath('..\makeStrainHistory\');
addpath('..\Optimization\');
addpath('..\matrixMethod\');
addpath('..\filtering\');
format long;
numberOfSensors = 3;
% Distance from reaction A to the middle sensor
L_a = 4.17/2;
% Distance from reaction A to sensor nearest Trondheim
L_b = L_a - 1;
% Distance from reaction A to sensor nearest Heimdal
L_c = L_a + 1;
sensorLocs = [L_a L_b L_c];
numberOfSensors = length(sensorLocs);
% TrainData, a struct which contains the axleDistances, weights, etc
TrainData = makeTrain();


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % Settings 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% TrainData.speed = 20.9875;
% TrainData.speed = 20.0;
influenceLines = readInfluenceLines(numberOfSensors);
read = 'true';
influenceLineIsFound = 'false';
create = 'true';
matrixMethod = 'true';
Optimization = 'true';
trainFileToRead = 4;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
if strcmp(read, 'true')
    [t, delta_t, s1, s2, s3, M] = readStrainFromFile(trainFileToRead);
    strainHistMat = [s1, s2, s3];
    figure(7);
    plot(t, s1, t, s2, t, s3);
    title('Raw strain history')
    legend('middle sensor', 'Trondheim sensor', 'Heimdal sensor');
    
    trainDirection = sign(speedByCorrelation(s2, s3, TrainData.time, 1, TrainData.delta)); % -1 <-> towards heimdal, 1 <-> towardsTrondheim
    if(trainDirection == -1) % Train goes towards heimdal
        
    elseif trainDirection == 1 % Train goes towards Trondheim
        L_a = TrainData.bridge_L - L_a;
        L_b = L_a + 1;
        L_c= L_a - 1;
        TrainData.axleDistances = fliplr(TrainData.axleDistances);
        TrainData.axleWeights = fliplr(TrainData.axleWeights);
    else
        disp('the data is identical or nonexistant')
        return;
    end
    if strcmp(influenceLineIsFound, 'true')
%        DO THE BWIM ROUTINE
        
    else
%        Do the optimization and or matrixMethod to find the influence line
%         findInfluenceLineFromRealStrain(sensorLocs);
        if (strcmp(matrixMethod, 'true'))
            increments = 1;
            figure(3)
            plot(t, strainHistMat(:,1));
            hold on;
            names = cell(increments+1,1);
            names{1} = ['measured strain'];
            currentError = Inf;
            currentSpeed = TrainData.speed;
            
            
            
            for  i = 2:increments+1
                [InfluenceLines, influenceMatrix, C] = influenceLineByMatrixMethod(TrainData, strainHistMat, sensorLocs, numberOfSensors);
                numberOfSamplesWanted = length(strainHistMat(:,1))-C(length(C))-1;
                deltaX = TrainData.bridge_L/numberOfSamplesWanted;
                x = 0:deltaX:TrainData.bridge_L;
                figure(2)
                plot(x, InfluenceLines(:,1), x, InfluenceLines(:,2), x, InfluenceLines(:,3))
                title('Calculated influence lines for Leirelva bridge')
                legend('middleInfl', 'towardsTrondheimInfl', 'towardsHeimdalInfl')
                Eps = influenceMatrix(:,1:TrainData.axles)*transpose(TrainData.axleWeights);
                %             sum(strainHistMat(:,1) - Eps)^2
                %             leastSquareFun = @(h)sum((strainHistMat(:,1) - Eps).^2);
                %             if(sum(strainHistMat(:,1) - Eps)^2 > 1e-6)
%                                 [vtest, InfluenceLinestest, influenceMatrixtest, Ctest, TrainDatatest] = optimizeForSpeed(TrainData, strainHistMat, sensorLocs, numberOfSensors);
                %             end
                
                error = sum((strainHistMat(:,1) - Eps).^2);
                if error < currentError
                    currentError = error;
                    currentSpeed = TrainData.speed;
                end
                figure(3)
                plot(t, Eps)
                names{i} = [' calc strain speed = ' num2str(TrainData.speed)];
                hold on;
%                 TrainData.speed = TrainData.speed + 0.0001;
            end
            title('Strainhistory, calculated vs measured')
            legend(names{:,1});
            
            calculatedSpeed = speedByCorrelation(strainHistMat(:,1), strainHistMat(:,2),  t, 1, delta_t);
        end
    end
end
if(strcmp(create, 'true'))
    % E modulus N/m^2             
    E = 200*10^9;                 
    % Section modulus (IPE 300 m^3
    Z = 3.14e5 / (1000^3);
    %   StrainHist is the one this program should use
    %   originalWONoiseOrDynamics, is the perfect signal without any noise
    %   or dynamic effects
    [strainHist, originalWONoiseOrDynamics ] = makeStrainHistory(TrainData,sensorLocs(1), E, Z );
    strainHistMat = zeros(length(strainHist), numberOfSensors);
    strainHistMat(:,1) = strainHist;
    perfectSignalMatrix= zeros(length(originalWONoiseOrDynamics), numberOfSensors);
    for i = 2:numberOfSensors
        [strainHist, originalWONoiseOrDynamics ] = makeStrainHistory(TrainData,sensorLocs(i), E, Z );
        strainHistMat(:,i) = strainHist;
        perfectSignalMatrix(:,i) = originalWONoiseOrDynamics;
    end

    if strcmp(influenceLineIsFound, 'true')
%        DO THE BWIM ROUTINE
        calculatedSpeed = speedByCorrelation(strainHistMat(:,1), strainHistMat(:,2), TrainData.time, L_b - L_a, TrainData.delta);
        [calculatedAxleDistances, locs] = axleDetection(strainHistMat(:,1), TrainData.time, calculatedSpeed);
    else
%        Do the optimization and or matrixMethod to find the influence line
        if (strcmp(matrixMethod, 'true'))
            [InfluenceLines, influenceMatrix, C] = influenceLineByMatrixMethod(TrainData, strainHistMat, sensorLocs, numberOfSensors);
            numberOfSamplesWanted = length(strainHist)-C(length(C))-1;
            deltaX = TrainData.bridge_L/numberOfSamplesWanted;
            x = 0:deltaX:TrainData.bridge_L;
            figure(4)
            plot(x, InfluenceLines(:,1), x, InfluenceLines(:,2), x, InfluenceLines(:,3))
            title('Calculated influence lines for theoretical strain history')
            legend('calculated middle', 'calculated trondheim', 'calculated heimdal')
            Eps = influenceMatrix(:,1:8)*transpose(TrainData.axleWeights);
            Eps2 = influenceMatrix(:,9:16)*transpose(TrainData.axleWeights);
            Eps3 = influenceMatrix(:,17:24)*transpose(TrainData.axleWeights);
            figure(5)
            plot(TrainData.time, Eps, TrainData.time, Eps2, TrainData.time, Eps3, TrainData.time, strainHistMat(:,1),  TrainData.time, strainHistMat(:,2),  TrainData.time, strainHistMat(:,3));
%             plot(TrainData.time, Eps, TrainData.time, strainHistMat(:,1));
            legend('calculated middle', 'calculated trondheim', 'calculated heimdal', 'actual middle', 'actual trond', 'actual heim')
        end
    end
end
  