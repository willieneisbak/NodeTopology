
function demo4_computeFnedViaSampling()

% this demo computes the fixed node edit distance (FNED) between two adjacency matrices using a sampling scheme



% make adjacency matrices A1 and A2
A1 = makeRandomFixedNodeGraph(20);
A2 = A1;
% modify A2 slightly: add edges between 3 & 4, 3 & 5, ..., and 3 & 9 
A2(3,4:9) = 1;
A2(4:9,3) = 1;

fprintf('Here is A1:\n'); disp(A1);
fprintf('Here is A2:\n'); disp(A2);
if A1 == A2
	fprintf('A1 is equal to A2.\n')
end


% initial map
maxNodes = max(length(A1),length(A2));
% map=[1:maxNodes];
% map = [1,randperm(maxNodes-1)+1];

% experiment: better munkres for better initialization
for i=1:maxNodes
	for j=1:maxNodes
		costmat(i,j)=abs(sum(A1(i,:)) - sum(A2(j,:)));
	end
end
[map,cost] = munkres(costmat)


fprintf(['Initial map: ',mat2str(map),'\n']);

% compute edgeXorSum for initial map:
edgeXorSumVec(1) = getEdgeXorSum(A1,A2,map);
fprintf(['Initial edgeXorSum: ',num2str(edgeXorSumVec(end)),'\n']);


% for each iter: pick some subset of the rows to randomly permute, compute edgeXorSum given this subset permutation, accept with some probability
tic
numChanges = 0;
fprintf('edgeXorSum per iter:');
for iter=1:50000

	% choose rows to permute
	
	% % experiment
	% if edgeXorSumVec(end) > 50
	% 	numRowsToPermute = 3;
	% else
	% 	numRowsToPermute = 2;
	% end
	numRowsToPermute=3;			% e.g. 5



	temp = randperm(maxNodes-1)+1;   % randomly ordered indices of rows (excluding the first row)
	rowsToPermute = temp(1:numRowsToPermute);   % 5 random rows	
	newMap = map;
	newMap(rowsToPermute) = newMap(rowsToPermute(randperm(numRowsToPermute)));% rowsToPermute(perm) is a permutation of the 5 random rows

	% compute new edgeXorSum of this state change
	newEdgeXorSum = getEdgeXorSum(A1,A2,newMap);

	% accept under some condition
	if newEdgeXorSum < edgeXorSumVec(end)
		changeMap = 1;
	elseif rand < (edgeXorSumVec(end)) / (300*newEdgeXorSum)
		changeMap = 1;
	else
		changeMap = 0;
	end

	% change state or keep previous state
	if changeMap == 1
		% update map
		map = newMap;
		% record change of map
		numChanges = numChanges + 1;
		% update sum
		edgeXorSumVec(end+1) = newEdgeXorSum;
	else
		edgeXorSumVec(end+1) = edgeXorSumVec(end);
	end
	% fprintf([' ', num2str(edgeXorSumVec(end))]);  %%% remove if i increase number of samples a lot
	fprintf(['iter: ',num2str(iter),'.  map: ',mat2str(map),'.  edgeXorSum: ',num2str(edgeXorSumVec(end)),'\n']);
end
fprintf('\n\n');

% save plot of sum of diff per iter
h = plot(edgeXorSumVec); ylim([0,200]);
saveas(h,'plotEdgeXorSum.pdf');

fprintf(['Map after %d iters: ',mat2str(map),'\n'], iter);
fprintf(['edgeXorSum after %d iters: ',num2str(edgeXorSumVec(end)),'\n'], iter);
fprintf('%d/%d mapping changes occured\n', numChanges, iter);
fprintf('%d iters took %f seconds\n', iter, toc);