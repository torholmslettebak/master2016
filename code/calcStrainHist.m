function strainHist = calcStrainHist(ordinateMatrix, axleWeights, E, Z)
	strainHist = ((1/(E*Z)) * ordinateMatrix * transpose(axleWeights)) ;
end

