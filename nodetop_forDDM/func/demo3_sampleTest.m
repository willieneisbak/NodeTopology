
function demo3_sampleTest()




% adjacency matrices A1 and A2

% A2 = [0 1 1 1 1; 1 0 0 0 1; 1 0 0 0 0; 1 0 0 0 1; 1 1 0 1 0];
% A1 = [0 1 1 1 1; 1 0 0 0 0; 1 0 0 1 0; 1 0 1 0 1; 1 0 0 1 0];

% A2 = [0 1 1 1 1 1; 1 0 0 0 1 0; 1 0 0 0 0 0; 1 0 0 0 1 0; 1 1 0 1 0 0; 1 0 0 0 0 0];
% A1 = [0 1 1 1 1 0; 1 0 0 0 0 0; 1 0 0 1 0 0; 1 0 1 0 1 0; 1 0 0 1 0 0; 0 0 0 0 0 0];

A1 = makeRandomFixedNodeGraph();
% A2 = makeRandomFixedNodeGraph(20);
A2 = A1;

% modify A2 slightly: add edges between 3 & 4, 3 & 5, ..., and 3 & 9 
% A2(3,4:9) = 1;
% A2(4:9,3) = 1;


fprintf('Here is A1:\n'); disp(A1);
fprintf('Here is A2:\n'); disp(A2);
if A1 == A2
	fprintf('A1 is equal to A2.\n')
end

% initial map
maxNodes = max(length(A1),length(A2));
% map=[1:maxNodes];
map = [1,randperm(maxNodes-1)+1];
fprintf(['Initial map: ',mat2str(map),'\n']);

% compute difference per row of initial map:
for r=1:length(map)
	diff(r) = sum(A2(map(r),:)) + sum(length(map(find(A1(r,:))))) - 2*sum(A2(map(r),map(find(A1(r,:)))));
end
fprintf(['Initial diff: ',mat2str(diff),'\n']);



% for each iter: pick two rows to switch, find new diff for both if switch occured, make switch final in mapping with some probability

tic
numChanges = 0;
sumDiff = [sum(diff)];
for iter=1:50000
	% choose r1 and r2 (the rows to switch)
	r1 = randi([2,length(map)]);
	r2 = randi([2,length(map)-1]);
	if r2>=r1 r2=r2+1; end

	% compute diff of each row switched
	diff1 = sum(A2(map(r2),:)) + sum(length(map(find(A1(r1,:))))) - 2*sum(A2(map(r2),map(find(A1(r1,:)))));
	diff2 = sum(A2(map(r1),:)) + sum(length(map(find(A1(r2,:))))) - 2*sum(A2(map(r1),map(find(A1(r2,:)))));

	% accept under some condition and switch mapping
	changeMap = 0;
	if diff1+diff2 < diff(r1)+diff(r2) % naive accept step right now
		changeMap = 1;
	else
		if rand < (diff(r1)+diff(r2)+1)/ (150*(diff1+diff2+diff(r1)+diff(r2)))
			changeMap = 1;
		end
	end
	if changeMap == 1
		% update map
		temp = map(r1);
		map(r1) = map(r2);
		map(r2) = temp;
		% update diff
		diff(r1) = diff1;
		diff(r2) = diff2;
		% record change of map
		numChanges = numChanges + 1;
	end
	sumDiff(end+1) = sum(diff);
end

% save plot of sum of diff per iter
h = plot(sumDiff); ylim([0,50]);
saveas(h,'plotSumDiff.pdf');

fprintf(['Map after %d iters: ',mat2str(map),'\n'], iter);
fprintf(['Diff after %d iters: ',mat2str(diff),'\n'], iter);
fprintf('%d/%d mapping changes occured\n', numChanges, iter);
fprintf('%d iters took %f seconds\n', iter, toc);