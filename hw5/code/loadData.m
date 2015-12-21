function [I, p0] = loadData(directory, prefix, extension, nFrames, ...
    pointFile, verbose) %#ok<STOUT>

if ~exist(directory, 'dir')
    error('Directory %s not found', directory);
end

pointPath = strcat(directory, filesep, pointFile);
if ~exist(pointPath, 'file')
    error('File %s not found', pointPath);
end

load(pointPath);
if verbose
    fprintf('Found %d points to track in file %s\n', size(p0, 2), pointPath);
end

if verbose
    fprintf('Loading %d images: ', nFrames);
end
I = [];
for i = 1:nFrames
    if verbose
        fprintf('%d ', i);
    end
    filename = sprintf('%s%c%s%04d.%s', ...
        directory, filesep, prefix, i, extension);
    if ~exist(filename, 'file')
        error('File %s not found', filename);
    end
    I = cat(3, I, double(imread(filename)));
end
if verbose
    fprintf('\n');
end
