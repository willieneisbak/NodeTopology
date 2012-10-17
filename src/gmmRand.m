function sample = gmmRand(muVec,sigVec,mixVec)

% this function returns a sample from a gaussian mixture model.
% with params: muVec=[mu1,mu2,...], sigVec=[sig1,sig2,...], mixVec=[mix1,mix2,...]


% check if mixture vec is normalized, and normalize it if not
if sum(mixVec) ~= 1
    fprintf('Mixture vector parameter does not sum to one. Normalizing now.\n');
    mixVec = mixVec / sum(mixVec);
end

% draw class
u = rand;
for i=1:length(mixVec)
    if u < sum(mixVec(1:i))
        class = i;
        break;
    end
end

% draw normal sample
mu = muVec(class);
sig = sigVec(class);
sample = normrnd(mu,sig);
