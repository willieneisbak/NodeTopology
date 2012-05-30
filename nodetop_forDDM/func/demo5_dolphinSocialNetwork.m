
function demo5_dolphinSocialNetwork()

% this demo carries out embedding of all nodes in the dolphinSocialNetwork dataset.
% nodes are embedded via 1-step local topologies
% mcmc is used to compute the fned for arbitrary graphs

% call this function from nodetop (most external) directory

% add functions to path
addpath(genpath('func'));

dolph = importdata('data/graphDataCsv/dolphinSocialNetwork.csv');
fprintf('Imported data.\n');

graph = dolph.data;
names = dolph.textdata(2:end,1);

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
xlim([-0.9,1.2]);
ylim([-0.2,1.1]);
box on
viz_plotGraphEmbedding(pc(:,1:2),graph,{},labels');
xlim([-0.9,1.2]);
ylim([-0.2,1.1]);
box on

% save workspace for later manipulation
save('demo5_dolphinSocialNetwork_results');