function p = blockPyramid(img)

% error checking

if ~ismatrix(img)
    error('Input must be a black-and-white image (two-dimensional array)');
end

imgSize = size(img);

if imgSize(1) ~= imgSize(2)
    error('Input must be a square matrix');
end

if (floor(log2(imgSize(1))) ~= log2(imgSize(1))) || (floor(log2(imgSize(1))) ~= log2(imgSize(2)))
    error('Each dimension must be a power of 2');
end

% main code

B = (1/4) .* [1, 1;1, 1];
rotB = rot90(B, 2);
rB = size(rotB, 1);
cB = size(rotB, 2);

p = {};
p{1} = img;

count = 2;
s = size(p{count-1});

leftPaddingSame = floor((cB-1)/2);
rightPaddingSame = cB-leftPaddingSame-1;
topPaddingSame = floor((rB-1)/2);
bottomPaddingSame = rB-topPaddingSame-1;

while s(1) > 1
    lastImgPadded = p{count-1};
    lastImgPadded = [zeros(size(lastImgPadded,1),leftPaddingSame) lastImgPadded];
    lastImgPadded = [lastImgPadded zeros(size(lastImgPadded,1),rightPaddingSame)];
    lastImgPadded = [zeros(topPaddingSame, size(lastImgPadded, 2));lastImgPadded];
    lastImgPadded = [lastImgPadded; zeros(bottomPaddingSame, size(lastImgPadded, 2))];
    
    rPadded = size(lastImgPadded, 1);
    cPadded = size(lastImgPadded, 2);
    
    r = 2;
    while r < rPadded
        c = 2;
        while c < cPadded
            zTemp = rotB.*lastImgPadded(r:r+rB-1, c:c+cB-1);
            Z(r/2,c/2) = sum(zTemp(:));
            c = c + 2;
        end
        r = r + 2;
    end
    
    p{count} = Z;
    Z = [];
    s = size(p{count});
    count = count + 1;
end

end