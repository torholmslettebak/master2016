function [a, b, c, d] =  generateInfluenceLine(L, L_a)
	magnitude = L_a*(1- L_a / L);
	a = magnitude/L_a;
	b=0;
	c = -magnitude/(L-L_a);
	d = magnitude;
end