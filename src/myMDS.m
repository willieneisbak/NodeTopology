function result = myMDS(distMat)

% this is my wrapper for MATLAB's cmdscale function (for "classical multidimensional scaling") to remove small issues with my result distance matrices.

if size(distMat,1)~=size(distMat,2)
    error('distance matrix input (distMat) must be a square matrix');
end

for i=1:length(distMat)
    for j=1:length(distMat)
        if i>j
            distMat(i,j) = distMat(j,i);
        end
    end
end

result = cmdscale(distMat);
fprintf('MATLAB''s cmdscale returned a matrix with %d rows and %d columns.\n', size(result,1), size(result,2));
