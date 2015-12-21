function gp = gMag(p)
    % K not necessary but wanted to show it
    K = (1/8) .* [1, 0, -1;
                  2, 0, -2;
                  1, 0, -1];
    K1 = (1/4) .* [1; 2; 1];
    K2 = (1/2) .* [1, 0, -1];
    
    gp = {};
    for i = 1:size(p, 2)
        gpTemp = imfilter(p{i}, K2, 'replicate');
        gp{i} = imfilter(gpTemp, K1, 'replicate');
    end
end