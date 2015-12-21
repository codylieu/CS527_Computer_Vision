function M = convMatrix(H, sA, type)

rotH = rot90(H, 2);

rA = sA(1);
cA = sA(2);

rH = size(rotH, 1);
cH = size(rotH, 2);

rB = rA + rH - 1;
cB = cA + cH - 1;

cMf = rA*cA;

Mf = [];

for c = 1:cB
    for r = 1:rB
        tempArr = zeros(1, cMf);
        for rBound = 1:rH
            for cBound = 1:cH
                if r+rBound-1 >= rH  && r+rBound <= rA+rH
                    if c+cBound-1>=cH && c+cBound <= cA+cH
                        origR = r+rBound-rH;
                        origC = c+cBound-cH;
                        y = (origC-1)*rA+origR;
                        tempArr(y) = rotH(rBound, cBound);
                    end
                end
            end
        end
        Mf = [Mf;tempArr];
    end
end

if strcmp(type, 'full') == 1
    M = Mf;
else
    Ms = [];
    
    leftPaddingSame = floor((cH-1)/2);
    rightPaddingSame = cH-leftPaddingSame-1;
    topPaddingSame = floor((rH-1)/2);
    bottomPaddingSame = rH-topPaddingSame-1;
    
    leftPaddingFull = cH-1;
    rightPaddingFull = cH-1;
    topPaddingFull = rH-1;
    bottomPaddingFull = rH-1;
    
    leftPaddingDiff = leftPaddingFull - leftPaddingSame;
    rightPaddingDiff = rightPaddingFull - rightPaddingSame;
    topPaddingDiff = topPaddingFull - topPaddingSame;
    bottomPaddingDiff = bottomPaddingFull - bottomPaddingSame;
    
    % take out rows lost by the left and right padding difference
    MsTemp = [];
    MsTemp = Mf((leftPaddingDiff*rB+1:end),:);
    
    MsSize = size(MsTemp);
    MsRow = MsSize(1);
    
    MsTemp = MsTemp((1:MsRow-(rightPaddingDiff*rB)),:);

    % then take out the rows lost by the top and bottom padding difference
    
    MsSize = size(MsTemp);
    MsRow = MsSize(1);
    for index = 1:rB:MsRow
        Ms = [Ms;MsTemp(index+topPaddingDiff:index+rB-1-bottomPaddingDiff,:)];
    end
    
    M = Ms;
end

end

