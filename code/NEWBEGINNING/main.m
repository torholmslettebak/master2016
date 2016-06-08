
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
averagedMatrix = [];
averagedXmatrix = [];
numberOfSensors = length(sensorLocs);
% TrainData, a struct which contains the axleDistances, weights, etc
% known_infl = load('averagedInfluenceline.mat');
% known_x = load('xvec_for_averaged_infl.mat');
strainHistMat = zeros(10000,3);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % Settings
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% TrainData.speed = 20.9875;
% TrainData.speed = 20.0;
influenceLines = readInfluenceLines(numberOfSensors);
read = 'false';
influenceLineIsFound = 'false';
create = 'true';       % 'true' to create a theoretical strain signal
matrixMethod = 'true';
Optimization = 'false';
Averaging = 'false';
sensors = [1 2 3];
% trainFilesToRead = [3 4 5 8];
trainFilesToRead = [3 4 5 6 8];
% trainFile 5 has wrong speed set i think.... crazy influence line -
% testing 21.485703515625005 , previous = 20.474 :!!!!!!!!! HAHA much
% fucking better result
% v3 = 20.99, new ? = 20.994 good
% v4 = 21.8, new ? = 21.7276 or 23.161212499999998
% v5 = 21.4857
% v6 = 16.82 , new ? = 16.843 or  16.829841406249997
% v7 = 23.801024999999999
% v8 = 20.633, new ? = 20.591465
speedTable = [20 20 20.99 21.7276 21.485703515625005 16.83 15.83 20.591465];
% speedTable = [0 0 23.04 21.8 20.474 0 0 20.633];
x_mat = zeros(4000,length(trainFilesToRead));
x_mat_optimization = zeros(4000,length(trainFilesToRead));
infl_mat = zeros(4000,length(trainFilesToRead));
infl_mat_optimization = zeros(4000,length(trainFilesToRead));
samples_before = inf;   % Used to determine where to cut influence line for averaging
samples_after = inf;
shortest_Signal_before = 0;
shortest_Signal_after = 0;
calculatedWeights = zeros(11,15);
columnCounter = 1;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
counter = 0;
if strcmp(read, 'true')
  for sensor = sensors
    infl_mat = zeros(4000,length(trainFilesToRead));
    infl_mat_optimization = zeros(4000,length(trainFilesToRead));
    counter = 0;
    for i = trainFilesToRead
      counter = counter + 1;      % Keeps track of which train is performed.. only because trainFiles have numbers like [3 4 5 6 8] and not 1 2 3 4 5 osv
      trainFileToRead = i;
      TrainData = makeTrain(speedTable(trainFileToRead), trainFileToRead);     % initializes TrainData
      [t, delta_t, s1, s2, s3, M] = readStrainFromFile(trainFileToRead, TrainData, sensorLocs); % reads strain into variables
      t = t -t(1); % sets time to begin at zero
      [ TrainData, L_a, L_b, L_c, trainDirection, sensorLocs ] = findDirAndShift( TrainData, s2, s3, sensorLocs ); % Finds direction of train and was previously used to change data to fit train direction, main currently takes care of this
      %         s1 = sgolayfilt(s1,3,71);
      %         s2 = sgolayfilt(s2,3,71);
      %         s3 = sgolayfilt(s3,3,71);
      original1 = s1;
      original2 = s2;
      original3 = s3;
      
                  s1 = fftFilter(s1, 1, length(s1), 20, 1024, 1:length(s1));
                  s2 = fftFilter(s2, 1, length(s2), 20, 1024, 1:length(s2));
                  s3 = fftFilter(s3, 1, length(s3), 20, 1024, 1:length(s3));
%       figure(3)
% %       subplot(2,1,1)
%       plot(t,original1, '.', t,s1)
%       plot()
%       legend('original signal')
%       ylabel('strain');
%       xlabel('time (s)');
%       fileNameString = ['..\..\thesis\tikz\raw_strain.tex' ];
%       matlab2tikz(fileNameString, 'height', '\textwidth', 'width', '\textwidth');
%       close(3)
% %       subplot(2,1,2)
%       figure(4)
% 
%       legend('signal filtered 20 Hz');
%       ylabel('strain');
%       xlabel('time (s)');
%       fileNameString = ['..\..\thesis\tikz\filtered_strain.tex' ];
%       matlab2tikz(fileNameString, 'height', '\textwidth', 'width', '\textwidth');
%       close(4);
      if trainDirection==1 % train comes in opposite direction of "normal", need to reverse data
        %             flip the strain signals
        direction = 'Trondheim';
        disp('THE TRAIN COMES FROM HEIMDAL');
        s1 = flipud(s1);    % flips strain history so that it appears the train comes from Trondheim
        s2 = flipud(s2);
        s3 = flipud(s3);
        original1 = flipud(original1);
        original2 = flipud(original2);
        original3 = flipud(original3);
      else
        direction = 'Heimdal';  % Normal directio
      end
      original = [original1 original2 original3];
      strainHistMat = [s1, s2, s3];
      numberOfSensors = 3;
      %              speedFOUND = findApproxSpeed( TrainData, strainHistMat, sensorLocs, numberOfSensors );
      %             speedByPeaks(s1, s2, s3, t, sensorLocs);
      figure(7);
      plot(t, s1, t, s2, t, s3);
      %         plot(t, sgolayfilt(s1,3,71), t, s1);
      titleString = ['strain for train: ' num2str(i)];
      %             fileNameString = ['..\..\thesis\tikz\raw_strain_train' num2str(i) '.tex' ];
      title(titleString)
      legend('middle sensor', 'Trondheim sensor', 'Heimdal sensor');
      xlabel('time [s]');
      ylabel('strain [\varepsilon]');
      %         matlab2tikz(fileNameString, 'height', '\figureheight', 'width', '\figurewidth');
      
      %         [ TrainData, L_a, L_b, L_c, trainDirection, sensorLocs ] = findDirAndShift( TrainData, s2, s3, sensorLocs );
      
      if strcmp(influenceLineIsFound, 'true')
        %        DO THE BWIM ROUTINE
        averagedX = load('shortFinalAveragedXmatrix.mat');
        averagedInfl = load('shortFinalAveragedMatrix.mat');
        averagedMatrix = averagedInfl.averagedMatrix;
        averagedXmatrix= averagedX.averagedXmatrix;
        %                 figure(1)
        %                 plot(removeZeroIndexesFromEnd(averagedXmatrix(:,1)), removeZeroIndexesFromEnd(averagedMatrix(:,1)), removeZeroIndexesFromEnd(averagedXmatrix(:,2)), removeZeroIndexesFromEnd(averagedMatrix(:,2)), removeZeroIndexesFromEnd(averagedXmatrix(:,3)), removeZeroIndexesFromEnd(averagedMatrix(:,3)));
        % 
        %                 title('Minimal influence lines')
        %                 xlabel('m')
        %                 ylabel('magnitude');
        %                 line([0 1], [0 -0.5e-9], 'Color','k', 'LineWidth', 1);
        %                 line([0 -1], [0 -0.5e-9], 'Color','k', 'LineWidth', 1);
        %                 line([-1 1], [-0.5e-9 -0.5e-9], 'Color','k', 'LineWidth', 1);
        %                 line([25 26], [0 -0.5e-9], 'Color','k', 'LineWidth', 1);
        %                 line([25 24], [0 -0.5e-9], 'Color','k', 'LineWidth', 1);
        %                 line([24 26], [-0.5e-9 -0.5e-9], 'Color','k', 'LineWidth', 1);
        %                 line([0 25], [0 0], 'Color','k', 'LineWidth', 1);
        %                 legend('infl sensor 1', 'infl sensor 2', 'infl sensor 3', 'bridge')
        %                 fileNameString = ['..\..\thesis\tikz\influenceLines\minimalInfluenceLines.tex' ];
        %                 matlab2tikz(fileNameString, 'height', '0.4\textwidth', 'width', '\textwidth');
        %                 close(1)
        calculatedWeights = calculateAxleWeights(averagedMatrix(:, sensor), averagedXmatrix(:, sensor), strainHistMat, TrainData, sensorLocs, sensor, calculatedWeights, columnCounter)
        columnCounter = columnCounter + 1;
      elseif strcmp(matrixMethod, 'true')
        %        Do the optimization and or matrixMethod to find the influence line
        %         findInfluenceLineFromRealStrain(sensorLocs);
        % if (strcmp(matrixMethod, 'true'))
        calculatedSpeed = speedByCorrelation(strainHistMat(:,2), strainHistMat(:,3),  TrainData.time, 2, TrainData.delta);
        [InfluenceLines, influenceMatrix, x] = inflMatrixMethod(strainHistMat, TrainData, sensorLocs, numberOfSensors, t, original, trainFileToRead);
        
        if trainDirection == -1 % Train goes towards Heimdal
          [x1] = shiftInfluenceLine( L_a, InfluenceLines(:,1), x );
          [x2] = shiftInfluenceLine( L_b, InfluenceLines(:,2), x );
          [x3] = shiftInfluenceLine( L_c, InfluenceLines(:,3), x );
        elseif trainDirection == 1 % Train goes towards Trondheim
          [x1] = shiftInfluenceLine( L_a, InfluenceLines(:,1), x );
          [x2] = shiftInfluenceLine( L_b, InfluenceLines(:,2), x );
          [x3] = shiftInfluenceLine( L_c, InfluenceLines(:,3), x );
        end
        if sensor == 1
          before = length(x1(x1<sensorLocs(1)));
          after = length(x1(x1>=sensorLocs(1)));
          x_mat(1:length(x1),counter) = x1;
          infl_mat(1:length(InfluenceLines(:,1)),counter) = InfluenceLines(:,1);
        elseif sensor == 2
          before = length(x2(x2<sensorLocs(2)));
          after = length(x2(x2>=sensorLocs(2)));
          x_mat(1:length(x2),counter) = x2;
          infl_mat(1:length(InfluenceLines(:,2)),counter) = InfluenceLines(:,2);
        elseif sensor == 3
          before = length(x3(x3<sensorLocs(3)));
          after = length(x3(x3>=sensorLocs(3)));
          x_mat(1:length(x3),counter) = x3;
          infl_mat(1:length(InfluenceLines(:,3)),counter) = InfluenceLines(:,3);
        end
        
        
        if(samples_before>(before))
          samples_before = before;
          shortest_Signal_before = counter;
        end
        if(samples_after > (after))
          samples_after = (after);
          shortest_Signal_after = counter;
        end
        
        %                     figure(31)
        %                     plot(x1, InfluenceLines(:,1), x2, InfluenceLines(:,2), x3, InfluenceLines(:,3))
        %                     plot(x1, InfluenceLines(:,1))
        % %                     line([0 1], [0 -1e-9], 'Color','k', 'LineWidth', 1);
        % %                     line([0 -1], [0 -1e-9], 'Color','k', 'LineWidth', 1);
        % %                     line([-1 1], [-1e-9 -1e-9], 'Color','k', 'LineWidth', 1);
        % %                     line([25 26], [0 -1e-9], 'Color','k', 'LineWidth', 1);
        % %                     line([25 24], [0 -1e-9], 'Color','k', 'LineWidth', 1);
        % %                     line([24 26], [-1e-9 -1e-9], 'Color','k', 'LineWidth', 1);
        % %                     line([0 25], [0 0], 'Color','k', 'LineWidth', 1);
        %                     %             line([25 25], [0 -3e-9], 'Color','k', 'LineWidth', 4);
        %                     %             line(X,Y,Z,'Color','r','LineWidth',4)
        %                     %             plot(x1, InfluenceLines(:,1));
        %                     title('Shifted influence lines for Leirelva bridge, sensor 1')
        % %                     legendString = ['train ' num2str(i) ' -> ' direction];
        %                     legendEntry = ['train ' num2str(trainFileToRead) ' -> ' direction]
        %                     legendString() = [legendString, legendEntry];
        %                     legend(legendString);
        %                     hold on;
        %                 legend('middleInfl', 'towardsTrondheimInfl', 'bridge')
        %                 hold on;
        %             Use the following method if speed is unknown.. finds best
        %             case error on the speed interval 16:24 m/s
        %                                     speedFOUND = findApproxSpeed( TrainData, strainHistMat, sensorLocs, numberOfSensors )
        
        %                 figure(10)
        %                 if trainDirection == 1
        % %                     x_mat(1:length(x1),counter) = fliplr(x1);
        % %                     infl_mat(1:length(InfluenceLines(:,1)),counter) = fliplr(InfluenceLines(:,1));
        %                     plot(x1, (InfluenceLines(:,1)));
        %                 else
        % %                     x_mat(1:length(x1),counter) = x1;
        % %                     infl_mat(1:length(InfluenceLines(:,1)),counter) = InfluenceLines(:,1);
        %
        %                 end
        %                                     plot(x1, (InfluenceLines(:,1)));
        %                                     fileName = ['..\..\thesis\tikz\infl_vec_correct_speed_train' num2str(i) '_sensorMiddle.tex' ];
        %                                     legendString = ['train ' num2str(i) ' sensor mid'];
        %                                     title('');
        %                                     xlabel('meters [m]');
        %                                     ylabel('magnitude');
        %                                     legend('train 5 infl');
        %                                     legend(legendString);
        %                                     cleanfigure();
        %                                     matlab2tikz(fileName, 'height', '\figureheight', 'width', '\figurewidth');
        %                     
        figure(11)
        plot(x2, (InfluenceLines(:,2)));
        fileName = ['..\..\thesis\tikz\infl_vec' num2str(i) '_sensor2.tex' ];
        legendString = ['train ' num2str(i) ', sensor2'];
        %                                     title('');
        xlabel('meters [m]');
        ylabel('magnitude');
        %                                     legend('train 5 -> Heimdal');
        legend(legendString);
        %                                     matlab2tikz(fileName, 'height', '\figureheight', 'width', '\figurewidth');
        %
        figure(12)
        plot(x3, (InfluenceLines(:,3)));
        fileName = ['..\..\thesis\tikz\infl_vec' num2str(i) '_sensor3.tex' ];
        legendString = ['train ' num2str(i) ', sensor 3'];
        %                 title('');
        xlabel('meters [m]');
        ylabel('magnitude');
        %                                     legend('train 3 -> Heimdal', 'train 4 -> Trondheim', 'train 5 -> Heimdal', 'train 6 -> Trondheim', 'train 8 -> Trondheim');
        legend(legendString);
        %                                     matlab2tikz(fileName, 'height', '\figureheight', 'width', '\figurewidth');
        %                 legendName = ['train ' num2str(i) ' -> ' direction];
        %                 legend(legendName);
        %                 hold on;
        %                 matlab2tikz(fileName, 'height', '\figureheight', 'width', '\figurewidth');
        %                 matlab2tikz('myplots.tex');
        
        
      elseif strcmp(Optimization, 'true')
        % %                     Do optimization to find influence lines,
        addpath('.\Optimization\');
        E = 1; Z = 1;
        type='polynomial';
        % %                 shift the initial guesses for the influence line, compare errors to find best case
        [ influenceLine, x, C ] = influenceLineByOptimization(s1, TrainData, sensorLocs(1), E, Z, type);
        %                 influenceLine = optimizeInfluenceLineALT(s1, TrainData, sensorLocs(1));
        C = axleDistancesInSamples(TrainData);
        numberOfSamplesWanted = length(strainHistMat(:,1))-C(length(C))-1;
        dx = TrainData.delta * TrainData.speed;
        x = [0:numberOfSamplesWanted]*dx;
        [x1] = shiftInfluenceLine( L_a, influenceLine, x );
        %                                     infl_mat_optimization(1:length(influenceLine), counter) = influenceLine;
        %                 x_mat_optimization(1:length(x1), counter) = x1;
        %                 figure(1)
        % %                 if trainDirection == 1
        % %                     plot(x1, fliplr(influenceLine));
        % %                 else
        % %                     plot(x1, influenceLine);
        % %                 end
        plot(x1, influenceLine);
        title('Shifted influence line, Optimization')
        hold on;
        %                 inflMatrixOptimized = genInflMatFromCalcInflLine( influenceLine, TrainData.axles, C);
        %                 Eps1 = inflMatrixOptimized*transpose(TrainData.axleWeights);
        %                 figure(11)
        %                 plot(t, s1, t, Eps1);
        %                 title('optimized strain history')
        %                 legend('original', 'optimized')
        %                 hold on;
        addpath('.\newOptimization\');
        type = 'polynomial';
        [ influenceLine, x, C ] = influenceLineByOptimization( strainHistMat(:,1), TrainData, sensorLocs(1), 1, 1, type)
        initialInfl = optimizationFlow(s1, TrainData, sensorLocs(1), known_infl.averaged);
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
  if strcmp(Averaging, 'true')
    figure(30)
    clf(30)
    for test = 1:length(infl_mat(1,:))
      plot(removeZeroIndexesFromEnd(x_mat(:,test)), removeZeroIndexesFromEnd(infl_mat(:,test)))
      hold on;
    end
    legend('Train 3 -> Heimdal', 'Train 4 -> Trondheim','Train 5 -> Heimdal', 'Train 6 -> Trondheim', 'Train 8 -> Trondheim')
    title(['influence lines for sensor: ' num2str(sensor)])
    xlabel('meters')
    ylabel('magnitude')
    %             fileNameString = ['..\..\thesis\tikz\infl_vec_all' num2str(sensor) '.tex'];
    %             matlab2tikz(fileNameString, 'height', '\textwidt', 'width', '\textwidth');
    InflData = struct('matrixMethod_infl_mat', infl_mat, 'x_values_infl_mat', x_mat, 'optimization_infl_mat', infl_mat_optimization, 'x_values_optimization', x_mat_optimization, 'sensorLoc', sensorLocs(sensor));
    [averaged, xvec] = averageInfluenceLines(InflData, TrainData, samples_before, samples_after, shortest_Signal_before, shortest_Signal_after, sensor);
    averagedMatrix(1:length(averaged), sensor) = averaged;
    averagedXmatrix(1:length(xvec),sensor) = xvec;
    %           cleanfigure();
  end
% end
%     if strcmp(matrixMethod, 'true')
%         trainFilesToRead = [3 4 5 6 8];
%         calculatedWeights = zeros(11,12);
%         columnCounter = 1;
%         for sensor = [2]
%             for train = trainFilesToRead
%                 trainFileToRead = train;
%                 disp(['this is train: ' num2str(train) ' and sensor: ' num2str(sensor)])
%                 TrainData = makeTrain(speedTable(trainFileToRead), trainFilesToRead);
%                 [t, delta_t, s1, s2, s3, M] = readStrainFromFile(trainFileToRead, TrainData, sensorLocs);
%                 t = t -t(1);
%                 [ TrainData, L_a, L_b, L_c, trainDirection, sensorLocs ] = findDirAndShift( TrainData, s2, s3, sensorLocs );
%                 %         s1 = sgolayfilt(s1,3,71);
%                 %         s2 = sgolayfilt(s2,3,71);
%                 %         s3 = sgolayfilt(s3,3,71);
%                 original1 = s1;
%                 original2 = s2;
%                 original3 = s3;
%                 
%                 %         s1 = fftFilter(s1, 1, length(s1), 10, 1024, 1:length(s1));
%                 %         s2 = fftFilter(s2, 1, length(s2), 10, 1024, 1:length(s2));
%                 %         s3 = fftFilter(s3, 1, length(s3), 10, 1024, 1:length(s3));
%                 if trainDirection==1
%                     %             flip the strain signals
%                     direction = 'Trondheim';
%                     disp('THE TRAIN COMES FROM HEIMDAL');
%                     s1 = flipud(s1);
%                     s2 = flipud(s2);
%                     s3 = flipud(s3);
%                     original1 = flipud(original1);
%                     original2 = flipud(original2);
%                     original3 = flipud(original3);
%                 else
%                     direction = 'Heimdal';
%                 end
%                 original = [original1 original2 original3];
%                 strainHistMat = [s1, s2, s3];
% %                 calculateAxleWeights(averagedMatrix(:, sensor), averagedXmatrix(:, sensor), strainHistMat, TrainData, sensorLocs, sensor)
%                 calculatedWeights = calculateAxleWeights(averagedMatrix(:, sensor), averagedXmatrix(:, sensor), strainHistMat, TrainData, sensorLocs, sensor, calculatedWeights, columnCounter)
%                 columnCounter = columnCounter + 1;
%             end
%         end
%     end
%     figure(10);
%     plot(xvec, averaged, '--');
%     title(['Influencelines for 4 trains, sensor ' num2str(sensor)]);
% legend('train 3 -> Heimdal', 'train 4 -> Trondheim', 'train 5 -> Heimdal', 'train 8 -> Trondheim', 'averaged influence line');
% matlab2tikz('..\..\thesis\tikz\infl_all.tex', 'height', '\figureheight', 'width', '\figurewidth');
% close(10)
end
if(strcmp(create, 'true'))
  % E modulus N/m^2
  E = 200*10^9;
  % Section modulus (IPE 300 m^3
  Z = 3.14e5 / (1000^3);
  TrainData = makeTrain(20,0);
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
      legend('Middle infl', 'trondheim infl', 'heimdal infl')
      xlabel('meters')
      ylabel('magnitude')
      fileNameString = ['..\..\thesis\tikz\influenceLinesFromCreatedStrain.tex'];
      %             matlab2tikz(fileNameString, 'height', '0.4\textwidth', 'width', '\textwidth');
      Eps = influenceMatrix(:,1:8)*transpose(TrainData.axleWeights);
      Eps2 = influenceMatrix(:,9:16)*transpose(TrainData.axleWeights);
      Eps3 = influenceMatrix(:,17:24)*transpose(TrainData.axleWeights);
      figure(5)
      %             plot(TrainData.time, Eps, TrainData.time, Eps2, TrainData.time, Eps3, TrainData.time, strainHistMat(:,1),  TrainData.time, strainHistMat(:,2),  TrainData.time, strainHistMat(:,3));
      plot(TrainData.time, strainHistMat(:,1),  TrainData.time, Eps);
%       title('Created strains, 20 m/s');
      %             plot(TrainData.time, Eps, TrainData.time, strainHistMat(:,1));
      legend('Created signal', 'recreated signal')
      fileNameString = ['..\..\thesis\tikz\strains\theoretical_signal_vs_recreated.tex'];
                  matlab2tikz(fileNameString, 'height', '0.4\textwidth', 'width', '\textwidth');
    end
    
  end
end
