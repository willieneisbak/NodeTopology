
function distance = nodeDist_twoStepTrue(node1Ind,node2Ind,graph)

% this function returns the "true" single fixed node graph isomorphism edit distance for two-step local topology subgraphs. It makes use of the hungarian algorithm.

% input: node1Ind, the index (row # in graph matrix) for node 1.
% input: node2Ind, the index (row # in graph matrix) for node 2.
% input: graph, the adjacency matrix of an undirected graph.

% output: distance, the true 1FN-GIED distance between node 1 and node 2 (for 2-step local topology).




% find children of node1 and node2
child1 = find(graph(node1Ind,:));
child2 = find(graph(node2Ind,:));

% make costMat
maxLength = max(length(child1),length(child2));

for i = 1 : maxLength
	for j = 1 : maxLength
		if length(child1) >= i  &&  length(child2) >= j
			costMat(i,j) = abs((sum(graph(child1(i),:))-1) - (sum(graph(child2(j),:))-1));
		else
			costMat(i,j) = Inf;
		end
	end
end

% make all Inf entries in costMat equal to max(costMat(:)) + 1
maxVal = max(costMat(find(costMat(:)~=Inf)));
costMat(find(costMat(:)==Inf)) = maxVal + 1;

% find optimal matching of children using Hungarian algorithm
[assignment, cost] = munkres(costMat);

% compute distance given this matching of children
distance = 0;
for i = 1 : maxLength
	match = assignment(i);
	if length(child1) >= i  &&  length(child2) >= match
		% find difference between the number of child nodes (for each child)
		distance = distance + abs((sum(graph(child1(i),:))-1) - (sum(graph(child2(match),:))-1));
	elseif length(child1) < i  &&  length(child2) >= match
		% if extra child (in second node), find the number of child nodes it has + 1
		distance = distance + (sum(graph(child2(match),:))-1) + 1;
	else
		% if extra child (in first node), find the number of child nodes it has + 1
		distance = distance + (sum(graph(child1(i),:))-1) + 1;
	end
end