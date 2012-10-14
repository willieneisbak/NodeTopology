function demo6_dickensCopperfield()

% this demo carries out embedding of all nodes in the davidCopperfieldGraph dataset.
% nodes are embedded via 1-step local topologies
% mcmc is used to compute the fned for arbitrary graphs

% call this function from nodetop (most external) directory

% add src to path
addpath(genpath('src'));

davCopp = importdata('data/graphDataCsv/davidCopperfieldGraph.csv');
fprintf('Imported data.\n');

graph = davCopp.data;
names = davCopp.textdata(2:end,1);

% make graph an undirected, redundant (each edge represented twice) adj matrix
for i = 1:length(graph)
	graph(i,find(graph(:,i))) = 1;
end

% get local topologies of all nodes
topCell = makeLocalTopologyGraphs(graph,1);

% use all nodes as basis nodes
basisNodes = [1:length(graph)];

% calculate fned of all pairs of nodes and basis nodes
for i = 1:length(graph)
	for j = 1:length(basisNodes)
		fnedMat(i,j) = getFned_mcmc(topCell{i},topCell{basisNodes(j)});
	end
	fprintf('Finished embedding for node: %d\n',i);
end


% display results

% load adjective / noun info
temp = importdata('data/graphDataCsv/davidCopperfieldGraph_nodeInfo.csv');
labels = temp.data(:,1);

% plot principle components
pc = princomp(fnedMat);
% slightly separate points for better visualization
pc = pc + 0.08*rand(length(pc),length(pc));
viz_plotGraphEmbedding(fnedMat(:,4:5),[],names(1:size(fnedMat,1)),labels');
box on
viz_plotGraphEmbedding(fnedMat(:,1:3),graph,{},labels');
box on

% save workspace for later manipulation
save('demo6_dickensCopperfield_results');
