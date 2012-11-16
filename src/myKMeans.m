function labels = myKMeans(data, k, numIter)

% this function carries out the k means clustering algorithm
% input:
%		data. each row is an example and each column a feature
%		k. number of clusters in k means
%		numIter. number of iterations of k means
% output: labels. each row gives a cluster label for each row in data input


if nargin < 1
	error('Must have data table as input');
end

% default number of clusters
if nargin < 2
	k = 10;
end

% default iter
if nargin < 3
	numIter = 50;
end

% initialize k means
% here i will intialize to k random data point
	% unless there are less data than k, then give error
if size(data,1) <= k
	error('You should make k less than the number of data points');
else
	 temp = [1:size(data,1)];
	 for a = 1 : k
	 	nextInd = floor((rand * length(temp)) - 0.0001) + 1;   % i don't want to use randi() in case system doesn't have it
	 	means(a,:) = data(temp(nextInd),:);
	 	temp(nextInd) = [];
	 end
end

% do k means numIter times
for iter = 1 : numIter
    
    disp(means)

	% assign each example to closest mean in means vec
	for k = 1 : size(means,1)
		diffmat = data - repmat(means(k,:), size(data,1), 1);
		distmat(:,k) = sqrt(sum(diffmat .* diffmat, 2));  % distmat(i,k) holds distance of i_th data to k_th mean
	end

	for i = 1 : size(data,1)
		[del, keep] = min(distmat(i,:));
		labels(i) = keep;
	end

	% assign each mean in means vec to mean of assigned examples
	for k = 1 : size(means,1)
		assignedInd = find(labels == k);
		means(k,:) = sum(data(assignedInd, :))/length(assignedInd); % compute mean
	end

	fprintf('iter complete = %d. ', iter);

end
fprintf('\n')
