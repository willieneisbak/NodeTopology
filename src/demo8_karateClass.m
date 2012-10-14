function demo8_karateClass()

% this demo carries out embedding of all nodes in the karate dataset.
% nodes are embedded via 1-step local topologies
% mcmc is used to compute the fned for arbitrary graphs

% call this function from nodetop (most external) directory

% add src to path
addpath(genpath('src'));

karate = importdata('data/graphDataCsv/karate.csv');

% put graph in consistent form as previous graphs
graph = karate(2:end,:);
graph = graph(:,2:end);
for i=1:length(graph)
    for j=1:length(graph)
        if i>j
            graph(j,i) = graph(i,j);
        end
    end
end
fprintf('Imported data: %d nodes.\n',length(graph));

% need to construct name-label cell to be consistent with others
for i=2:length(karate)
    names{i-1} = num2str(karate(1,i));
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

% save workspace for later manipulation
save('demo8_karateClass_results');
