function sample = gmmRand(muVec,sigVec,mixVec)

% sample from a gaussian mixture model
% with params: muVec=[mu1,mu2,...], sigVec=[sig1,sig2,...], mixVec=[mix1,mix2,...]


% normalize mixture vec, just in case
mixVec = mixVec / sum(mixVec);

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
