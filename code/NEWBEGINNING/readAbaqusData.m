% filename = '150pkt_alle_sensorer - Copy.rpt';
clear all;
filename = '500pkt.rpt';
delimiterIn = ' ';
headerlinesIn = 3;
A = importdata(filename,delimiterIn, headerlinesIn);
A = A.data;
figure(1)
plot(A(:,1), -1*A(:,2),A(:,1), -A(:,3),A(:,1), -A(:,4))
l = legend('sensor 1', 'sensor 2',' sensor 3')
title('Influence lines from abaqus')
xlabel('x')
ylabel('magnitude')
l.Location = 'northwest';
cleanfigure();
fileName = ['C:\Users\Rot\master2016\thesis\tikz\influenceLinesAbaqus.tex'];
% ['..\..\thesis\tikz\infl_vec_correct_speed_train' num2str(i) '_sensorMiddle.tex' ];
matlab2tikz(fileName, 'height', '\figureheight', 'width', '\figurewidth');