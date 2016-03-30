function [  ] = readStrain(  )
%READSTRAIN Summary of this function goes here
%   Detailed explanation goes here
% 1603161026.txt
% load('makeStrainHistory\train\1603161026.txt')
format long;
addpath('filtering');
path = 'makeStrainHistory\train\';
files = dir('makeStrainHistory\train\*.txt');
M = dlmread([path files(3).name],' ',2,0);
t = M(:,1);
s1 = M(:,2);
s2 = M(:,3);
s3 = M(:,4);
delta_t = t(2)-t(1);
freq = findNoiseFrequency(s1(1:100), 100*delta_t);
denoisedS1 = denoiseSignal(s1, freq);
diff1 = diff((denoisedS1));
mean(denoisedS1)
[pks, locs, w, p] = findpeaks(diff1, 'MinPeakHeight',mean(diff1)*100);
test = denoisedS1(locs(1):locs(length(locs)));
figure(1)
plot(t, denoisedS1, t, s2, t, s3, t(locs(1):locs(length(locs))), test);
% plot(t, denoisedS1, t, s2, t, s3, t(1:length(t)-2), diff1)
legend('Sensor1', 'Sensor2','Sensor3');
figure(2)
plot(t(1:length(t)-1), diff1);
% for i = 2:length(files)
%    load(files(i).name)
% end
% filename = files(2).name;
% fileID = fopen(files(1).name, 'r');
% C = textscan(fileID, '%f', '%f', '%f', '%f');
% C = textscan(fileID,'%f',4,'Delimiter','');
% fclose(fileID);
% files(2).name
% fileID = fopen(files(2).name, 'r');

% filename = files(2).name;
% M = dlmread(filename,' ',2,0)
% C = textscan(fileID, '%f', 'Delimiter', ' ');
% for i=1:length(files)
%     
%     tline = fgets(fileID);
%     tline = fgets(files(i).name);
%     eval(['load ' files(i).name ' -ascii']);
% end
% fileID = fopen('1603161026.txt','r');
% tline = fgets(fileID);

end

