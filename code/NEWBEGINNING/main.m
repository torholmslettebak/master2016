
clear; clc; clf;
close all;
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


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % Settings 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% TrainData.speed = 20.9875;
% TrainData.speed = 20.0;
influenceLines = readInfluenceLines(numberOfSensors);
read = 'true';
influenceLineIsFound = 'false';
create = 'false';
matrixMethod = 'true';
Optimization = 'true';
trainFilesToRead = [3];
% trainFilesToRead = [5];
% trainFile 5 has wrong speed set i think.... crazy influence line
speedTable = [0 0 20.99 21.8 20.474 0 0 20.633];
% speedTable = [0 0 23.04 21.8 20.474 0 0 20.633];
x_mat = zeros(4000,length(trainFilesToRead));
x_mat_optimization = zeros(4000,length(trainFilesToRead));
infl_mat = zeros(4000,length(trainFilesToRead));
infl_mat_optimization = zeros(4000,length(trainFilesToRead));

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
counter = 0;
if strcmp(read, 'true')
    for i = trainFilesToRead
        counter = counter + 1;
        trainFileToRead = i;
        TrainData = makeTrain(speedTable(trainFileToRead));
        [t, delta_t, s1, s2, s3, M] = readStrainFromFile(trainFileToRead, TrainData, sensorLocs);
        [ TrainData, L_a, L_b, L_c, trainDirection, sensorLocs ] = findDirAndShift( TrainData, s2, s3, sensorLocs );
        if trainDirection==1
%             flip the strain signals
            s1 = fliplr(s1);
            s2 = fliplr(s2);
            s3 = fliplr(s3);
        end
        strainHistMat = [s1, s2, s3];
        figure(7);
        plot(t, s1, t, s2, t, s3);
        title('Raw strain history')
        legend('middle sensor', 'Trondheim sensor', 'Heimdal sensor');
%         [ TrainData, L_a, L_b, L_c, trainDirection, sensorLocs ] = findDirAndShift( TrainData, s2, s3, sensorLocs );
        
        if strcmp(influenceLineIsFound, 'true')
            %        DO THE BWIM ROUTINE
            
        else
            %        Do the optimization and or matrixMethod to find the influence line
            %         findInfluenceLineFromRealStrain(sensorLocs);
            if (strcmp(matrixMethod, 'true'))
                calculatedSpeed = speedByCorrelation(strainHistMat(:,2), strainHistMat(:,3),  TrainData.time, 2, TrainData.delta);
                [InfluenceLines, influenceMatrix, x] = inflMatrixMethod(strainHistMat, TrainData, sensorLocs, numberOfSensors, t);
                
                if trainDirection == -1 % Train goes towards Heimdal
                    [x1] = shiftInfluenceLine( L_a, InfluenceLines(:,1), x );
                    [x2] = shiftInfluenceLine( L_b, InfluenceLines(:,2), x );
                    [x3] = shiftInfluenceLine( L_c, InfluenceLines(:,3), x );
                elseif trainDirection == 1 % Train goes towards Trondheim
                    [x1] = shiftInfluenceLine( L_a, InfluenceLines(:,1), x );
                    [x2] = shiftInfluenceLine( L_b, InfluenceLines(:,2), x );
                    [x3] = shiftInfluenceLine( L_c, InfluenceLines(:,3), x );
                end
                figure(6)
                plot(x1, InfluenceLines(:,1), x2, InfluenceLines(:,2), x3, InfluenceLines(:,3))
%                 plot(x1, InfluenceLines(:,1), x2, InfluenceLines(:,2))
                line([0 1], [0 -1e-9], 'Color','k', 'LineWidth', 1);
                line([0 -1], [0 -1e-9], 'Color','k', 'LineWidth', 1);
                line([-1 1], [-1e-9 -1e-9], 'Color','k', 'LineWidth', 1);
                line([25 26], [0 -1e-9], 'Color','k', 'LineWidth', 1);
                line([25 24], [0 -1e-9], 'Color','k', 'LineWidth', 1);
                line([24 26], [-1e-9 -1e-9], 'Color','k', 'LineWidth', 1);
                line([0 25], [0 0], 'Color','k', 'LineWidth', 1);
                %             line([25 25], [0 -3e-9], 'Color','k', 'LineWidth', 4);
                %             line(X,Y,Z,'Color','r','LineWidth',4)
                %             plot(x1, InfluenceLines(:,1));
                title('Shifted influence lines for Leirelva bridge')
                legend('middleInfl', 'towardsTrondheimInfl', 'towardsHeimdalInfl','bridge start', 'bridge')
%                 legend('middleInfl', 'towardsTrondheimInfl', 'bridge')
                hold on;
                %             Use the following method if speed is unknown.. finds best
                %             case error on the speed interval 16:24 m/s
%                             speedFOUND = findApproxSpeed( TrainData, strainHistMat, sensorLocs, numberOfSensors )
                x_mat(1:length(x1),counter) = x1;
                infl_mat(1:length(InfluenceLines(:,1)),counter) = InfluenceLines(:,1);
                figure(10)
                if trainDirection == 1
                    plot(x1, fliplr(InfluenceLines(:,1)));
                else
                    plot(x1, (InfluenceLines(:,1)));
                end
                
                hold on;
            end
            if strcmp(Optimization, 'true')
%                     Do optimization to find influence lines, 
                addpath('.\Optimization\');
                E = 1; Z = 1;
                type='polynomial';
%                 shift the initial guesses for the influence line, compare errors to find best case
%                 [ influenceLine, x, C ] = influenceLineByOptimization(s1, TrainData, sensorLocs(1), E, Z, type);
                influenceLine = optimizeInfluenceLineALT(s1, TrainData, sensorLocs(1));
                C = axleDistancesInSamples(TrainData);
                numberOfSamplesWanted = length(strainHistMat(:,1))-C(length(C))-1;
                dx = TrainData.delta * TrainData.speed;
                x = [0:numberOfSamplesWanted]*dx;
                [x1] = shiftInfluenceLine( L_a, influenceLine, x );
                infl_mat_optimization(1:length(influenceLine), counter) = influenceLine;
                x_mat_optimization(1:length(x1), counter) = x1;
                figure(1)
                if trainDirection == 1
                    plot(x1, fliplr(influenceLine));
                else
                    plot(x1, influenceLine);
                end
                title('Shifted influence line, Optimization')
                hold on;
                inflMatrixOptimized = genInflMatFromCalcInflLine( influenceLine, TrainData.axles, C);
                Eps1 = inflMatrixOptimized*transpose(TrainData.axleWeights);
                figure(11)
                plot(t, s1, t, Eps1);
                title('optimized strain history')
                legend('original', 'optimized')
                hold on;
            end
        end
    end
%     averaged = averageInfluenceLines(x_mat, infl_mat, TrainData);
InflData = struct('matrixMethod_infl_mat', infl_mat, 'x_values_infl_mat', x_mat, 'optimization_infl_mat', infl_mat_optimization, 'x_values_optimization', x_mat_optimization);
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
  