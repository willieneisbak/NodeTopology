
function topCell = makeLocalTopologyGraphs(graph,k)

% this function makes the k-step local topology graphs (adjacency matrices) for each node in an input graph

% input: graph, an adjacency matrix representing a graph. For now assumed to be a binary (1-0) matrix symmetric about the diagonal (i.e. duplicate edges shown), depicting an undirected graph.
% input: k, denoting the k-step local topology.

% output: topCell, a cell containing the set of adjacency matrices representing the local topologies of all nodes in graph.


% check if graph is square
if size(graph,1)~=size(graph,2)
	error('Input graph needs to be square');
end

% check if graph has nodes with self-edges
if sum(diag(graph))>0
	error('Input graph has nodes with self-edges. Not currently supported.')
end

% k currently fixed at 1
if nargin < 2  ||  k~=1
	k=1;
	disp('Currently only k=1 is supported. k set to 1.')
end


topCell = {};

% loop through each node in the input graph
for i = 1:size(graph,1)
	children = find(graph(i,:));
	map = [];
	map(children) = [2:length(children)+1];
	
	% make local topology adj matrix
	locTop = zeros(length(children)+1);
	% add edges for root node
	locTop(map(children),1) = 1;
	locTop(1,map(children)) = 1;

	% find edges to other children and add to locTop
	for j = 1:length(children)
		edgesToOtherChildren = intersect(find(graph(children(j),:)),children);
		if length(edgesToOtherChildren)>0
			locTop(j+1,map(edgesToOtherChildren)) = 1;
			locTop(map(edgesToOtherChildren),j+1) = 1;
		end
	end
	topCell{end+1} = locTop;
end