function [X, vis]= imgHOG(imgName, winSize, random)

img = rgb2gray(imread(imgName));

imgSize = size(img);

if random == 0
    s = floor((imgSize(1:2) - winSize) / 2) + 1;
else
    bound = imgSize(1:2) - winSize + 1;
    rs = floor(rand(random, 1) * (bound(1) - 1) + 1);
    cs = floor(rand(random, 1) * (bound(2) - 1) + 1);
    s = [rs, cs];
end

n = size(s, 1);
for k = 1:n
    f = s(k, :) + winSize - 1;
    detail = img(s(k, 1):f(1), s(k, 2):f(2));
    if random == 0 && nargout > 1
        [x, vis] = extractHOGFeatures(detail);
    else
        x = extractHOGFeatures(detail);
    end
    if k == 1
        X = zeros(n, length(x));
    end
    X(k, :) = x;
end