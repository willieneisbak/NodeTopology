function demo9_celegansNeural()

% this demo carries out embedding of all nodes in the celegansNeural dataset.
% this dataset is directed, but we remove all arrow-heads to get an undirected graph.
% nodes are embedded via 1-step local topologies
% mcmc is used to compute the fned for arbitrary graphs

% call this function from nodetop (most external) directory

% add src to path
addpath(genpath('src'));

neural = importdata('data/graphDataCsv/celegansNeural.csv');

% put graph in consistent form as previous graphs
digraph = neural(2:end,:);
digraph = digraph(:,2:end);
for i=1:length(digraph)
    for j=1:length(digraph)
        graph(i,j) = digraph(i,j) + digraph(j,i);
    end
end
fprintf('Imported data: %d nodes.\n',length(graph));

% need to construct name-label cell to be consistent with others
for i=2:length(neural)
    names{i-1} = num2str(neural(1,i));
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
save('demo9_celegansNeural_results');
