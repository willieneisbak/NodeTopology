function demo10_netscience()

% this demo carries out embedding of all nodes in the netscience dataset.
% this dataset is weighted, but we convert from weights to discrete "numbers of edges".
% nodes are embedded via 1-step local topologies
% mcmc is used to compute the fned for arbitrary graphs

% call this function from nodetop (most external) directory

% add src to path
addpath(genpath('src'));

net = importdata('data/graphDataCsv/netscience.csv');

% put graph in consistent form as previous graphs
for i=2:length(net)
    tmp = regexp(net{i},';','split');
    tmp = tmp(2:end);
    for j=1:length(tmp)
        graph(i-1,j) = floor(5*str2num(tmp{j}));
    end
end

fprintf('Imported data: %d nodes.\n',length(graph));

% need to construct name-label cell to be consistent with others
names = regexp(net{1},';','split');
names = names(2:end);

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


% perform clustering and display results

% cluster: kmeans with 10 means, it should naturally reduce to a decent value (such as 2 or 3)
labels = myKMeans(fnedMat,10,200);

% plot principle components
pc = princomp(fnedMat);
% slightly separate points for better visualization
pc = pc + 0.008*rand(length(pc),length(pc));
viz_plotGraphEmbedding(pc(:,1:2),[],names(1:size(fnedMat,1)),labels');
box on
viz_plotGraphEmbedding(pc(:,1:2),graph,{},labels');
box on

% plot mds coordinates
md = myMDS(fnedMat);
viz_plotGraphEmbedding(md(:,1:2),[],names(1:size(fnedMat,1)),labels');
box on
viz_plotGraphEmbedding(md(:,1:2),graph,{},labels');
box on

% save workspace for later manipulation
save('demo10_netscience_results');
