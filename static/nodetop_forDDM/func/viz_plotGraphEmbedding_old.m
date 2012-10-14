
function viz_plotGraphEmbedding(nodeData,graph,textCell,labels)

% this function plots the graph in (up to) 3 dimensions, based on the euclidean embedding.

% input: nodeData, a matrix where ith row is the node embedding vector for node i
% input: graph, the adjacency matrix of a graph
% input: textcell, a (linear) cell of text labels for the nodes
% input: labels, a vector of labels (i.e. from a clustering algorithm)

% note: if graph is given as input, this function automatically draws graph edges



% default linesOn = 0
if nargin < 2
	linesOn = 0;
else
	linesOn = 1;
end

% only keep first three features of nodeData
	% later on, I might want to call a lower-dim embedding function here
if size(nodeData,2)>3
	nodeData = nodeData(:,1:2);
	fprintf('viz: only the first three features of the nodeData matrix are used (other features discarded)\n');
end

% % regularize each component of nodeData to be in [0,1]
for i = 1 : size(nodeData,2)
	nodeData(:,i) = nodeData(:,i) / max(nodeData(:,i));
end

% slightly perturn nodeData matrix to resolve overlapping nodes (i.e. with same topology)
temp = 0.05*rand(size(nodeData,1),size(nodeData,2));
nodeData = nodeData + temp;

% plot nodeData
if size(nodeData,2)==3
	figure, plot3(nodeData(:,1), nodeData(:,2), nodeData(:,3), 'o', 'MarkerSize', 10);
elseif size(nodeData,2)==2
	% figure, plot(nodeData(:,1), nodeData(:,2), 'o');
	figure, scatter(nodeData(:,1), nodeData(:,2),50*ones(size(nodeData,1),1),labels, 'filled');
else
	error('viz: nodeData matrix must have either 2 or 3 features (# of columns).');
end
axis square
axis vis3d

% plot text if textCell given as argument
if nargin>2
	if size(textCell,1)<size(nodeData,1)
		error('Invalid textCell argument. Too few text elements.');
	end
	for i = 1 : size(nodeData,1)
		%text(nodeData(i,1)+0.5*(2*rand-1),nodeData(i,2)+0.05*(2*rand-1),nodeData(i,3)+0.05*(2*rand-1),num2str(i),'FontWeight','bold');
		if size(nodeData,2) == 2
			text(nodeData(i,1),nodeData(i,2),textCell{i},'FontWeight','bold','FontSize',12);
		elseif size(nodeData,2) == 3
			text(nodeData(i,1)+0.1*(2*rand-1),nodeData(i,2)+0.1*(2*rand-1),nodeData(i,3)+0.1*(2*rand-1),textCell{i},'FontWeight','bold','FontSize',12);
		end			
	end
end

% plot graph lines if linesOn = 1
	% note: for undirected graph with "redundant" adjacency matrix, this plots edges twice
	% note: for directed graph, this plot does not specify edge direction
hold on
if linesOn == 1
	for i = 1 : size(graph,1)
		edgesTo_i = find(graph(i,:));
		for j = 1 : length(edgesTo_i)
			jInd = edgesTo_i(j);
			if size(nodeData,2)==3
				plot3(nodeData([i,jInd],1),nodeData([i,jInd],2),nodeData([i,jInd],3),'k');
			else % i.e. size(nodeData,2)==2
				plot(nodeData([i,jInd],1),nodeData([i,jInd],2),'k');
			end
		end
	end
end