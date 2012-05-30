
function nodeData = embedInEuc_twoStepTrue_randomBasisNodes(graph,numBasisNodes)

% this function returns a euclidean embedding of the nodes in an undirected graph. The embedding is a vector of differences from a set of random basis nodes. Differences are the true two-step difference in an undirected graph (using Hungarian algorithm once).

% input: graph, the adjacency matrix of an undirected graph
% output: nodeData, a matrix where ith row is the node embedding vector for node i


if nargin<1
	error('You must include a graph (adjacency matrix) as an argument');
end

if size(graph,1) ~= size(graph,2)
	error('graph (adjacency matrix) input must be a square matrix');
end

% specify embedding dimension (must be less than the number of nodes)
	% default is 3
if nargin < 2
	numBasisNodes = 3;
end
if numBasisNodes > size(graph,1)
	error('The input graph has less nodes than the specified number of basis nodes');
end

% choose basis nodes
	% basisNodes vec contains indices (row #s) of nodes in graph chosen to be basis nodes
temp = [1:size(graph,1)];
for i = 1 : numBasisNodes
	nextInd = floor((rand * length(temp)) - 0.0001) + 1;
	basisNodes(i) = temp(nextInd);
	temp(nextInd) = [];
end

% for each node, compute distance to all basis nodes:
	% i.e. embed all nodes
for i = 1 : size(graph,1)
	for j = 1 : length(basisNodes)
		nodeData(i,j) = nodeDist_twoStepTrue(i,basisNodes(j),graph);
	end
	fprintf('finished embedding node: %d/%d\n', i, size(graph,1));
end