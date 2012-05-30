
function test()


names = {'1','2','3','4','5','6','7','8','9','10'};

for i = 1:10
	for j = 1:10
		distMat(i,j) = abs(i-j);
	end
end

distMat
size(distMat)
size(names)
pc = princomp(distMat);
pc = pc + 0.008*rand(length(pc),length(pc));
% viz_plotGraphEmbedding(pc(:,1:2),[],names(1:size(distMat,1)));
viz_plotGraphEmbedding(pc(:,1:2),[],names);

% viz_plotGraphEmbedding(pc(:,1:2),graph,{});