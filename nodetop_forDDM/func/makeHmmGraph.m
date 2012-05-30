
function hmm = makeHmmGraph(backboneLength)

% this function makes a HMM graph
% backboneLength is the number of nodes in the backbone, ie not emissions or corners (default set to 10)
% returns hmm, an adjacency matrix of the directed graph

% note: in hmm matrix, odd rows are backbone nodes and even rows are emission nodes. first row is first corner, and 2nd to last row (ie last odd row) is second corner

% i_th row are the nodes that node i "directs to"
% j_th column are the nodes that "direct to" node j



if nargin < 1
	backboneLength = 10;
end

numNodes = (backboneLength + 2) * 2;
hmm = zeros(numNodes);

% add corners
hmm(1,2) = 1;	% emission for 1st corner
hmm(1,3) = 1;	% chain for 1st corner

hmm(numNodes-1, numNodes) = 1; % emission for 2nd corner

for i = 3:2:numNodes-3
	hmm(i,i+1) = 1;
	hmm(i,i+2) = 1;
end