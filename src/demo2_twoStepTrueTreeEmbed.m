function demo2_twoStepTrueTreeEmbed()

% this demo carries out two step true euclidean embedding on a tree graph


% make tree
% ---------
% tree = makeRandomTree(4,20);
% tree = makeSimpleTree();
tree = makeKChildTree(5,4);
fprintf('Constructd a tree with %d nodes.\n', size(tree,1))

% embed nodes
% -----------
tic
numBasisNodes = size(tree,1);
treeData = embedInEuc_twoStepTrue_randomBasisNodes(tree,numBasisNodes);
fprintf('Embedding the %d nodes into %d dimensions took %f seconds.\n', size(tree,1), numBasisNodes, toc);

% plot embedded graph
% -------------------
%viz_plotGraphEmbedding(princomp(treeData'),tree);
%viz_plotGraphEmbedding(princomp(treeData'));
%viz_plotGraphEmbedding(treeData,tree);
viz_plotGraphEmbedding(treeData);
saveas(gcf,'graphEmbed.pdf');
saveas(gcf,'graphEmbed.fig');
