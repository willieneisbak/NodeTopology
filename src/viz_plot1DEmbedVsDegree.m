function handle = viz_plot1DEmbedVsDegree(nodeData,graph,textCell,labels)

% this function plots the 1D-embedding for each node vs each node's degree.

% input: nodeData, a matrix where ith row is the node embedding vector for node i
% input: graph, the adjacency matrix of a graph
% input: textcell, a (linear) cell of text labels for the nodes
% input: labels, a vector of labels (i.e. from a clustering algorithm)

% only keep first column (ie the 1D embedding of the data)
nodeData = nodeData(:,1);

% REGULARIZE EMBEDDING (to be in [0,1])
nodeData = nodeData / max(nodeData);

% GET EDGE DEGREES
degrees = sum(graph)';

% SLIGHTLY PERTURB DATA (both degrees and nodeDate, to resolve overlapping nodes with same topology)
temp1 = 0.04*rand(length(nodeData),1);
temp2 = 0.04*rand(length(degrees),1);
nodeData = nodeData + temp1;
degrees = degrees + temp2;

% CREATE FIGURE 
figure,

% PLOT
hold on
if nargin<=3
    plot(degrees,nodeData,'x-','LineWidth',2);
else
    scatter(degrees,nodeData,80*ones(length(nodeData),1),labels,'filled','o','MarkerEdgeColor','k');
end
axis square
box on

% SET CUSTOM COLORMAP (for better colors)
temp = colormap(hsv);
temp = temp(1:40,:);
colormap(temp);

% PLOT TEXT (if textCell given as argument)
noiseAmt = 0.01;
if nargin>2 && length(textCell)>=length(nodeData)
	for i = 1 : length(nodeData)
		text(degrees(i),nodeData(i)+noiseAmt*(2*rand-1),textCell{i},'FontWeight','bold','FontSize',12);
	end
end
