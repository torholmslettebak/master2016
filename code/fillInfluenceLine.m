function [yValue,x] =  fillInfluenceLine(a, b, c, d, L_a, L)
	x1 = 0:0.1:L_a;
	x2 = L_a:0.1:L;
	y1 = a*x1 + b;
	y2 = c*(x2-L_a) + d;
	y2(1) = [];
	x2(1) = [];
	x = [x1, x2];
	y = [y1,y2];
	yValue = y;

    figure(1);
    plot(x,y)
    title('Influence Lines for sensors');
    xlabel('x [m]');
    ylabel('magnitude');

end

