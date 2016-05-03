function [ influencematrix ] = genInflMatFromCalcInflLine( Infl, numberOfaxles, C )
%GENINFLMATFROMCALCINFLLINE Summary of this function goes here
%   Detailed explanation goes here
influencematrix = zeros(length(Infl+C(length(C))), numberOfaxles);
for i = 1:numberOfaxles
%     counter = C(i);
%     for j = 1:length(Infl)
%         influencematrix(counter+j, i) = Infl(j);
%     end
%     if(i ==1)
%         influencematrix(C(i)+1:length(Infl),i) = Infl(1:length(Infl));
%     else
        influencematrix(C(i)+1:length(Infl)+C(i),i) = Infl(1:length(Infl));
%     end
end
end