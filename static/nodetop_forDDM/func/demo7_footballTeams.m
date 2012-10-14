
function demo7_footballTeams()

% this demo carries out embedding of all nodes in the footballMatchups dataset.
% nodes are embedded via 1-step local topologies
% mcmc is used to compute the fned for arbitrary graphs

% call this function from nodetop (most external) directory

% add functions to path
addpath(genpath('func'));

footb = importdata('data/graphDataCsv/footballMatchupsGraph.csv');
fprintf('Imported data.\n');
graph = footb.data;
names = footb.textdata(2:end,1);

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
temp = importdata('data/graphDataCsv/footballMatchupsGraph_nodeInfo.csv');
labels = temp.data(:,1);

% plot principle components
pc = princomp(fnedMat);
% slightly separate points for better visualization
pc = pc + 0.05*rand(length(pc),length(pc));
viz_plotGraphEmbedding(pc(:,1:2),[],names(1:size(fnedMat,1)),labels');
xlim([-0.95,1.1]);
ylim([-.21,1.05]);
box on
viz_plotGraphEmbedding(pc(:,1:2),graph,{},labels');
xlim([-0.95,1.1]);
ylim([-.21,1.05]);
box on

% save workspace for later manipulation
save('demo7_footballTeams_results');