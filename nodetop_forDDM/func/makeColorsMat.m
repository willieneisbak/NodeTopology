
function colorMat = makeColorMat(labels)

% this function returns a color matrix (colorMat) for using scatter on labeled data


% note: when you save a graph in matlab that uses the colors made here, it won't save as pdf in vector format



uniq = unique(labels);
map(uniq) = [1:length(uniq)];

colorsCell = {[1 0 0], [0 0 1], [0 1 0]};

for i = 1:length(labels)
	if map(labels(i)) <= length(colorsCell)
		colorMat(i,:) = colorsCell{map(labels(i))};
	else
		colorsCell{end+1} = [rand,rand,rand];
		colorMat(i,:) = colorsCell{map(labels(i))};
	end
end