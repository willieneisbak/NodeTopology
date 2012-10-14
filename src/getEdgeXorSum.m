function xorSum = getEdgeXorSum(A1,A2,map)

% this function computes the overlap between the edges of two graphs, given a mapping from the nodes of the first graph to the nodes of the other graph

% input: A1, the adjacency matrix of the first graph (size nxn)
% input: A2, the adjacency matrix of the second graph (size nxn)
% input: map, the mapping, a vector where m(i) takes the i_th row in A1 to the m(i)_th row in A2

% output: xorSum, the total edge non-overlap given the two graphs and the mapping
%	which I often write as d(A1,A2,map)


% give error if matrices aren't the same size (for now)
if size(A1,1) ~= size(A2,1)  ||  size(A1,2) ~= size(A2,2)  %%%% will this hurt compute time a lot?
	error('Matrices are not the same size.');
end

% give error if matrices aren't square (for now)
if size(A1,1) ~= size(A1,2)  %%%% will this hurt compute time a lot?
	error('Matrices are not square.')
end

% computer xorSum
numRows = length(A1);
matM = repmat(map',1,numRows) + repmat([0:numRows-1],numRows,1)*numRows;
matMap = matM(:,map);
xorSum = length(find(A1(matMap)~=A2))/2;
