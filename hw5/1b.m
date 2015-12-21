for i = 1:6
	feature = sN{4, i};
	H = feature.current.H;
	c = cond(H);
	minS = min(svd(H));
	% disp(svd(H))
	disp(H)
	disp(strcat(num2str(i), ' & ', num2str(c, '%0.2f'), ' &  ', num2str(minS, '%0.2f'),  '\\'))
end

