function handle = viz_plotGraphEmbedding(nodeData,graph,textCell,labels)

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
	nodeData = nodeData(:,1:3);
	fprintf('viz: only the first three features of the nodeData matrix are used (other features discarded)\n');
end

% regularize each component of nodeData to be in [0,1]
for i = 1 : size(nodeData,2)
	nodeData(:,i) = nodeData(:,i) / max(nodeData(:,i));
end

% slightly perturn nodeData matrix to resolve overlapping nodes (i.e. with same topology)
 temp = 0.07*rand(size(nodeData,1),size(nodeData,2));
 nodeData = nodeData + temp;

% CREATE FIGURE 
figure,

% PLOT EDGES (if linesOn = 1)
	% node: do this first so edges are below nodes in visualization
	% note: for undirected graph with "redundant" adjacency matrix, this plots edges twice
	% note: for directed graph, this plot does not specify edge direction
%edgeColor = 'k';
edgeColor = [0 0 0]; % edgeColor = [0.25 0.25 0.25]; % <--for dark grey
hold on
if linesOn == 1
	for i = 1 : size(graph,1)
		edgesTo_i = find(graph(i,:));
		for j = 1 : length(edgesTo_i)
			jInd = edgesTo_i(j);
			if size(nodeData,2)==3
				edge = plot3(nodeData([i,jInd],1),nodeData([i,jInd],2),nodeData([i,jInd],3));
			else % i.e. size(nodeData,2)==2
				edge = plot(nodeData([i,jInd],1),nodeData([i,jInd],2));
			end
            set(edge,'Color',edgeColor);
		end
	end
end

% PLOT NODES 
hold on
if nargin<=3
	% make plot of nodeData
	if size(nodeData,2)==3
		plot3(nodeData(:,1), nodeData(:,2), nodeData(:,3), 'o', 'MarkerSize', 10);
		axis vis3d
	elseif size(nodeData,2)==2
		plot(nodeData(:,1), nodeData(:,2), 'o');
	else
		error('viz: nodeData matrix must have either 2 or 3 features (# of columns).');
	end
else
	% make scatter plot instead if labels given
	if size(nodeData,2)==3
		scatter3(nodeData(:,1),nodeData(:,2),nodeData(:,3),100*ones(size(nodeData,1),1),labels,'filled');
	elseif size(nodeData,2)==2
		scatter(nodeData(:,1),nodeData(:,2),100*ones(size(nodeData,1),1),labels,'filled');
	else
		error('viz: nodeData matrix must have either 2 or 3 features (# of columns).');
	end
end
axis square
box on

% SET CUSTOM COLORMAP (for better colors)
temp = colormap(hsv);
temp = temp(1:40,:);
colormap(temp);

% PLOT TEXT (if textCell given as argument)
noiseAmt = 0.01;
if nargin>2 && length(textCell)>=size(nodeData,1)
	for i = 1 : size(nodeData,1)
		%text(nodeData(i,1)+0.5*(2*rand-1),nodeData(i,2)+0.05*(2*rand-1),nodeData(i,3)+0.05*(2*rand-1),num2str(i),'FontWeight','bold');
		if size(nodeData,2) == 2
			text(nodeData(i,1),nodeData(i,2),textCell{i},'FontWeight','bold','FontSize',12);
		elseif size(nodeData,2) == 3
			text(nodeData(i,1)+noiseAmt*(2*rand-1),nodeData(i,2)+noiseAmt*(2*rand-1),nodeData(i,3)+noiseAmt*(2*rand-1),textCell{i},'FontWeight','bold','FontSize',12);
		end			
	end
end
