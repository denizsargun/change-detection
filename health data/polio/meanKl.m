function m = meanKl(numBin)
    % find the expected kl divergence between two distributions p, q sampled
    % independently and uniformly over the numBin-1 dimensional probability simplex
    it = numBin^5;
    kl = zeros(it,1);
    for i = 1:it
        r = exprnd(ones(2*numBin,1));
        p = r(1:numBin)/sum(r(1:numBin));
        q = r(numBin+1:2*numBin)/sum(r(numBin+1:2*numBin));
        llr = log(p./q);
        kl(i) = p'*llr;
    end
%     histogram(kl);
    m = mean(kl);
end