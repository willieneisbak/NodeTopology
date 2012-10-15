function tree = makeRandomTree(numLevels,maxNodesPerLevel)

% this function makes a random undirected tree graph

% input: numLevels, the number of "levels" in a tree constructed from an initial root node (including the root node level)
% input: maxNodesPerLevel, the maximum number of children to be generated at each level
% output: tree, adjacency matrix of constructed random tree graph



% print status
fprintf('Constructing random tree...');

% make nodes at each level
levels{1} = [0];
numNodes = 1;

% make children nodes for the other levels
for l = 2 : numLevels
	levels{l} = [];
	% for each row in previous level, make children in a loop
	for i = 1 : size(levels{l-1},1)
		% make random number of children
		numChildren = floor((rand * maxNodesPerLevel) - 0.0001) + 1;
		% "add children" to previous level matrix
		levels{l-1}(i,numNodes+1:numNodes+numChildren) = 1;
		% 
		levels{l}(end+1:end+numChildren,1) = 0;
		% increase the number of nodes
		numNodes = numNodes + numChildren;
	end
end

% duplicate "transpose" of all entries (make adjacancy matrix redundant)
	% i.e. we already added the "children" edges, and now to add the "parent edges"

% numPrevLevelNodes holds the number of nodes in all previous levels
numPrevLevelNodes = 0;
% parentNode gives index of column denoting parent node
parentNode = 0;

% loop through all levels and all nodes (rows) in each level
for l = 1 : numLevels-1
	% update number of nodes in previous levels
	numPrevLevelNodes = numPrevLevelNodes + size(levels{l},1);
	for i = 1 : size(levels{l},1)
		% current node (row) in current level considered parent node
		parentNode = parentNode + 1;
		% we find children of this parent node
		childrenOfParentNode = find(levels{l}(i,:)==1);
		% we subtract number of nodes in previous levels from children indices
		childrenOfParentNode = childrenOfParentNode - numPrevLevelNodes;
		% we add parent edges to each of the children in the next level
			% set these as 2, so we know they are "children" when loop is at next level
		levels{l+1}(childrenOfParentNode,parentNode) = 2;
	end
end

% make full tree graph
tree = [];
for l = 1 : numLevels
	for i = 1 : size(levels{l},1)
		onInd = find(levels{l}(i,:));
		tree(end+1,onInd) = 1;
	end
end
