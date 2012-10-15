function graph = makeRoleGraph(nodeDegree,numInterConnects)

% return a random graph with nodeDegree number of neighbors and numInterConnects number of connections between neighbors.

numNodes = nodeDegree+1;
graph = zeros(numNodes); % size is number of neighbors plus root node
graph(2:end,1) = 1; % add edges to neighbors
graph(1,2:end) = 1; % add edges to neighbors (symmetric)

% for each numInterConnects, add an edge between two nodes
for i=1:numInterConnects
    node1 = randi(numNodes-1) + 1;
    node2 = randi(numNodes-1) + 1;
    if node1==node2 % no self edges
        if node2 < numNodes
            node2 = node2+1;
        else
            node2 = node2-1; % if node2 is largest index node can't make it a higher index node.
        end
    end
    graph(node1,node2) = graph(node1,node2)+1;
    graph(node2,node1) = graph(node2,node1)+1;
end
