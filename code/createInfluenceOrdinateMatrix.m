% needs the influence line, axle distance, and time stuff
function ordinateMatrix = createInfluenceOrdinateMatrix(t,axleWeights, v, L, a, b, c, d, L_a, d_a)
	numberOfAxles = length(axleWeights);
	ordinateMatrix = zeros(length(t), numberOfAxles);
% 	train = zeros(1,numberOfAxles);
    train = true;
% 	while train

		for i = 1:(length(t))
			s1 = v*t(i);
			% disp(s1)
			if s1<=L
				y1 = getOrdinateValue(a, b, c, d, s1, L_a);
				ordinateVector = zeros(1,numberOfAxles);
				% disp(y1)
				ordinateVector(1,1) = y1;
% 			else
% 				% disp('HERE!')
% 				train(1,1) = 1;
% 				return;
			end
			% ordinateMatrix(1,1:numberOfAxles) = ordinateVector(1:numberOfAxles)
			if numberOfAxles>1
				for axle = 2:numberOfAxles
                    
                    
                    
					if (s1 - d_a*(axle-1))>0 && (s1 <= (L+ d_a*(axle-1)))
						ordinateVector(1,axle) = getOrdinateValue(a,b,c,d,s1-d_a*(axle-1), L_a);
%                     elseif (s1 - d_a*(axle-1) < 0)
% 						
%                     else
%                         train(1, axle) = 1;
					end
                    if axle==numberOfAxles && s1>L+d_a*(axle-1)
                        disp(s1>L+d_a*(axle-1));
                        train=false;

					% if s1-d_a*(axle-1) >30
					% 	train(1, axle) = 1;
					% end
                    end
				end
				% 
            end
            
			ordinateMatrix(i,1:numberOfAxles) = ordinateVector(1:numberOfAxles);
            if train == false;
                return;
            end
		end
% 	end
end


