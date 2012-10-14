
function fned = getFned_mcmc(A1,A2)

% this function computes the fixed node edit distance (FNED) between two local topologies via MCMC/sampling.

% input: A1, adjacency matrix of the first local topology (square matrix, any size)
%			fixed "root" node assumed to be in row/column 1
% input: A2, adjacency matrix of the second local topology (square matrix, any size)
%			fixed "root" node assumed to be in row/column 1

% output: fned, the fixed node edit distance between the two local topologies




% check if graphs are square
if size(A1,1)~=size(A1,2)  ||  size(A2,1)~=size(A2,2)
	error('Input adjacency matrices should be square.')
end

% check if graphs have no nodes with self-edges
if sum(diag(A1))>0  ||  sum(diag(A2))>0
	error('Input adjacency matrices should not have nodes with self edges.');
end


% adjust smaller of the adjacency matrices
if length(A1)==length(A2)
	maxNodes = length(A1);
elseif length(A1)>length(A2)
	maxNodes = length(A1);
	A2(end+1:maxNodes,:) = 0;
	A2(:,end+1:maxNodes) = 0;
else 
	maxNodes = length(A2);
	A1(end+1:maxNodes,:) = 0;
	A1(:,end+1:maxNodes) = 0;
end

% initialize with Hungarian algorithm
for i=1:maxNodes
	for j=1:maxNodes
		costmat(i,j)=abs(sum(A1(i,:)) - sum(A2(j,:)));
	end
end
[map,cost] = munkres(costmat);

% compute edgeXorSum for initial map:
edgeXorSumVec(1) = getEdgeXorSum(A1,A2,map);

% sample optimal mapping to compute fned
tic
numChanges = 0;
for iter=1:1000  %%%% fixed number of iters

	% can only permute up to maxNodes-1 node mappings
	if maxNodes>=4 
		numRowsToPermute=3; %%%% fixed number of rows to permute per iter
	else
		numRowsToPermute = maxNodes-1;
	end

	temp = randperm(maxNodes-1)+1;   % randomly ordered indices of rows (excluding the first row).
	rowsToPermute = temp(1:numRowsToPermute);   % e.g. 3 random rows	
	newMap = map;
	newMap(rowsToPermute) = newMap(rowsToPermute(randperm(numRowsToPermute)));% rowsToPermute(perm) is a permutation of the e.g. 3 random rows

	% compute new edgeXorSum of this state change
	newEdgeXorSum = getEdgeXorSum(A1,A2,newMap);

	% accept under some condition
	if newEdgeXorSum < edgeXorSumVec(end)
		changeMap = 1;
	elseif rand < (edgeXorSumVec(end)) / (200*newEdgeXorSum)
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

	% if sampler hits 0, local topologies are isomorphic, can return fned = 0
	if edgeXorSumVec(end)==0
		break
	end

	% remove before production %%%%
	% fprintf(['iter: ',num2str(iter),'.  map: ',mat2str(map),'.  edgeXorSum: ',num2str(edgeXorSumVec(end)),'\n']);
end

% return min sampled value as fned
fned = min(edgeXorSumVec);