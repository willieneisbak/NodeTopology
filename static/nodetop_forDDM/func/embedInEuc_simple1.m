
function nodeData = embedInEuc_simple1(graph)

% this function returns a euclidean embedding of each node in a directed graph.  The embedding of a node is a 2-tuple =  (# outgoing edges, # incoming edges).

% input: graph, the adjacency matrix of a (directed) graph.
% output: nodeData, a matrix where each row is a node embedding.


if nargin<1
	error('You must include a graph (adjacency matrix) as an argument');
end

if size(graph,1) ~= size(graph,2)
	error('graph (adjacency matrix) input must be a square matrix');
end



% construct simple euc representation for each node in graph
nodeData = zeros(size(graph,1),2);
for i = 1 : size(graph,1)
	nodeData(i,1) = sum(graph(i,:));
	nodeData(i,2) = sum(graph(:,i));
end

