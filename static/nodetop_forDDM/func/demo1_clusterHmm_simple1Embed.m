
function demo1_clusterHmm_simple1Embed()

% this carries out kmeans clustering on simple1 eucEmbedding of hmm graph data


hmm = makeHmmGraph(10);
hmmData = embedInEuc_simple1(hmm);
labels = myKMeans(hmmData, 10);

% show eucEmbedding of data in each cluster
diffLabels = unique(labels);
for i = 1 : length(diffLabels)
	hmmData(find(labels == diffLabels(i)), :)
end