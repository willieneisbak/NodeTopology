
function adjMat = makeRandomFixedNodeGraph(numNodes)

% this function makes a random undirected square graph with numNodes nodes
% input: numNodes, the number of nodes in the graph
% output: adjMat, an adjacency matrix of the random graph of size numNodes x numNodes


% default numNodes
if nargin < 1
	numNodes = 10;
	fprintf('NumNodes not specified as input. Default 10 nodes chosen.\n');
end


% for purposes of the Fixed Node Graph Edit Distance demo, I will have all nodes be adjacent to the first node in the graph (and no self edges in this graph)
adjMat(1,1) = 0;
adjMat(1,2:numNodes) = 1;
adjMat(2:numNodes,1) = 1;
% % initialize all other edges to zero
% adjMat(numNodes,numNodes)=0;

for i=1:randi([2*numNodes, 4*numNodes])
	% choose two random nodes r1 and r2 (r1~=r2, neither=1) and place edge between them (do nothing if edge already exists between them)
	r1 = randi([2,numNodes]);
	r2 = randi([2,numNodes-1]);
	if r2>=r1 r2=r2+1; end
	adjMat(r1,r2)=1;
	adjMat(r2,r1)=1;
end