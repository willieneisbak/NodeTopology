function fnedMat = demo11_synthRoleGraphs()

% specify a distribution over roles (e.g. two mixture distributions), compute FNED for each pair of role-graphs generated and place into fnedMat


% role mixture distributions are below
sigscale = 0.001
mu1 = [2,6]; sig1 = [sigscale,sigscale]; mix1 = [0.5,0.5]; % gaussian mixture for nodeDegree
mu2 = [0,2]; sig2 = [sigscale,sigscale]; mix2 = [0.5,0.5]; % gaussian mixture for numInterConnects

numNodes = 50;
topCell = {};
for i=1:numNodes
    nodeDegree = ceil(gmmRand(mu1,sig1,mix1)); % discretize sample from gmm
    if nodeDegree<0
        nodeDegree = 0; % don't let sample be negative
    end
    numInterConnects = ceil(gmmRand(mu2,sig2,mix2)); % discretize sample from gmm
    if numInterConnects<0
        numInterConnects = 0; % don't let sample be negative
    end
    topCell{end+1} = makeRoleGraph(nodeDegree,numInterConnects);
    fprintf('nodeDegree: %d  numInterConnects: %d\n', nodeDegree, numInterConnects);
end
fprintf('Completed making %d local-topology graphs.\n',numNodes);

% use all nodes as basis nodes
basisNodes = [1:numNodes];

% calculate fned of all pairs of nodes and basis nodes
for i = 1:numNodes
	for j = 1:length(basisNodes)
		fnedMat(i,j) = getFned_mcmc(topCell{i},topCell{basisNodes(j)});
	end
	fprintf('Finished embedding for node: %d\n',i);
end



%% perform clustering and display results

%% cluster: kmeans with 10 means, it should naturally reduce to a decent value (such as 2 or 3)
%labels = myKMeans(fnedMat,10,200);

%% plot principle components
%pc = princomp(fnedMat);
%% slightly separate points for better visualization
%pc = pc + 0.008*rand(length(pc),length(pc));
%viz_plotGraphEmbedding(pc(:,1:2),[],names(1:size(fnedMat,1)),labels');
%box on
%viz_plotGraphEmbedding(pc(:,1:2),graph,{},labels');
%box on

%% save workspace for later manipulation
%save('demo11_synthRoleGraphs_results');
