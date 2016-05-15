
clear; clc; clf;
close all;
addpath('..\')
addpath('..\makeStrainHistory\');
addpath('..\Optimization\');
addpath('..\matrixMethod\');
addpath('..\filtering\');
addpath('.\matlab2tikz\src\');
addpath('..\matlab2tikz\src\');
addpath('../../thesis/figures/')
% addpath('.\matlab2tikz\src\private\');
format long;
numberOfSensors = 3;
[ L_a, L_b, L_c, sensorLocs ] = setSensorLocs();
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
create = 'false';       % 'true' to create a theoretical strain signal
matrixMethod = 'true';
Optimization = 'false';
% trainFilesToRead = [3 4 5 8];
trainFilesToRead = [3 4 5 6 8];
% trainFile 5 has wrong speed set i think.... crazy influence line
speedTable = [20 20 20.99 21.8 20.474 16.83 20 20.633];
% speedTable = [0 0 23.04 21.8 20.474 0 0 20.633];
x_mat = zeros(4000,length(trainFilesToRead));
x_mat_optimization = zeros(4000,length(trainFilesToRead));
infl_mat = zeros(4000,length(trainFilesToRead));
infl_mat_optimization = zeros(4000,length(trainFilesToRead));
samples_before = inf;   % Used to determine where to cut influence line for averaging
samples_after = inf;
shortest_Signal_before = 0;
shortest_Signal_after = 0;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
counter = 0;
if strcmp(read, 'true')
    for i = trainFilesToRead
        counter = counter + 1;
        trainFileToRead = i;
        TrainData = makeTrain(speedTable(trainFileToRead));
        [t, delta_t, s1, s2, s3, M] = readStrainFromFile(trainFileToRead, TrainData, sensorLocs);
        t = t -t(1);
        [ TrainData, L_a, L_b, L_c, trainDirection, sensorLocs ] = findDirAndShift( TrainData, s2, s3, sensorLocs );
        if trainDirection==1
%             flip the strain signals
            direction = 'Trondheim';
            disp('THE TRAIN COMES FROM HEIMDAL');
            s1 = flipud(s1);
            s2 = flipud(s2);
            s3 = flipud(s3);
        else
            direction = 'Heimdal';
        end
        strainHistMat = [s1, s2, s3];
        figure(7);
        plot(t, s1, t, s2, t, s3);
        titleString = ['Raw strain freight train']
        fileNameString = ['..\..\thesis\tikz\raw_strain_train' num2str(i) '.tex' ]
        title(titleString)
        legend('middle sensor', 'Trondheim sensor', 'Heimdal sensor');
        xlabel('time [s]');
        ylabel('strain');
%         matlab2tikz(fileNameString, 'height', '\figureheight', 'width', '\figurewidth');

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
                before = length(x1(x1<sensorLocs(1)));
                after = length(x1(x1>=sensorLocs(1)));
                if(samples_before>(before))
                   samples_before = before;
                   shortest_Signal_before = counter;
                end
                if(samples_after > (after))
                   samples_after = (after);
                   shortest_Signal_after = counter;
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
%                 speedFOUND = findApproxSpeed( TrainData, strainHistMat, sensorLocs, numberOfSensors )
                x_mat(1:length(x1),counter) = x1;
                infl_mat(1:length(InfluenceLines(:,1)),counter) = InfluenceLines(:,1);
                figure(10)
                if trainDirection == 1
%                     x_mat(1:length(x1),counter) = fliplr(x1);
%                     infl_mat(1:length(InfluenceLines(:,1)),counter) = fliplr(InfluenceLines(:,1));
                    plot(x1, (InfluenceLines(:,1)));
                else
%                     x_mat(1:length(x1),counter) = x1;
%                     infl_mat(1:length(InfluenceLines(:,1)),counter) = InfluenceLines(:,1);
                    plot(x1, (InfluenceLines(:,1)));
                end
%                 fileName = ['..\..\thesis\tikz\infl_vec' num2str(i) '.tex'];
%                 title('');
                xlabel('meters [m]');
                ylabel('magnitude');
                legend('train 3 -> Heimdal', 'train 4 -> Trondheim', 'train 5 -> Heimdal', 'train 6 -> Trondheim', 'train 8 -> Trondheim');
%                 legendName = ['train ' num2str(i) ' -> ' direction];
%                 legend(legendName);
                hold on;
%                 matlab2tikz(fileName, 'height', '\figureheight', 'width', '\figurewidth');
%                 matlab2tikz('myplots.tex');
                
            end
            if strcmp(Optimization, 'true')
% %                     Do optimization to find influence lines, 
%                 addpath('.\Optimization\');
%                 E = 1; Z = 1;
%                 type='polynomial';
% %                 shift the initial guesses for the influence line, compare errors to find best case
% %                 [ influenceLine, x, C ] = influenceLineByOptimization(s1, TrainData, sensorLocs(1), E, Z, type);
%                 influenceLine = optimizeInfluenceLineALT(s1, TrainData, sensorLocs(1));
%                 C = axleDistancesInSamples(TrainData);
%                 numberOfSamplesWanted = length(strainHistMat(:,1))-C(length(C))-1;
%                 dx = TrainData.delta * TrainData.speed;
%                 x = [0:numberOfSamplesWanted]*dx;
%                 [x1] = shiftInfluenceLine( L_a, influenceLine, x );
%                 infl_mat_optimization(1:length(influenceLine), counter) = influenceLine;
%                 x_mat_optimization(1:length(x1), counter) = x1;
%                 figure(1)
% %                 if trainDirection == 1
% %                     plot(x1, fliplr(influenceLine));
% %                 else
% %                     plot(x1, influenceLine);
% %                 end
%                 plot(x1, influenceLine);
%                 title('Shifted influence line, Optimization')
%                 hold on;
%                 inflMatrixOptimized = genInflMatFromCalcInflLine( influenceLine, TrainData.axles, C);
%                 Eps1 = inflMatrixOptimized*transpose(TrainData.axleWeights);
%                 figure(11)
%                 plot(t, s1, t, Eps1);
%                 title('optimized strain history')
%                 legend('original', 'optimized')
%                 hold on;
                addpath('.\newOptimization\');
                initialInfl = optimizationFlow(s1, TrainData, sensorLocs(1))
            end
        end
        [ L_a, L_b, L_c, sensorLocs ] = setSensorLocs();
    end
%     averaged = averageInfluenceLines(x_mat, infl_mat, TrainData, sensorLocs(1), samples_before, samples_after);
%         addpath('.\matlab2tikz\src\');
% cleanfigure();
% matlab2tikz('..\..\thesis\tikz\infl_matrix_all.tex', 'height', '\figureheight', 'width', '\figurewidth');
%         matlab2tikz('myfile.tex', 'height', '\figureheight', 'width', '\figurewidth');
%         matlab2tikz('myfile.tex');
% cleanfigure();
% matlab2tikz('..\..\thesis\tikz\infl_vec_all.tex', 'height', '\textwidt', 'width', '\textwidth');
InflData = struct('matrixMethod_infl_mat', infl_mat, 'x_values_infl_mat', x_mat, 'optimization_infl_mat', infl_mat_optimization, 'x_values_optimization', x_mat_optimization, 'sensorLoc', sensorLocs(1));
[averaged, xvec] = averageInfluenceLines(InflData, TrainData, samples_before, samples_after, shortest_Signal_before, shortest_Signal_after);
cleanfigure();

% figure(10);
% plot(xvec, averaged, '--');
% title('Influencelines for 4 trains, middle sensor');
% legend('train 3 -> Heimdal', 'train 4 -> Trondheim', 'train 5 -> Heimdal', 'train 8 -> Trondheim', 'averaged influence line');
% matlab2tikz('..\..\thesis\tikz\infl_all.tex', 'height', '\figureheight', 'width', '\figurewidth');
% close(10)
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
  