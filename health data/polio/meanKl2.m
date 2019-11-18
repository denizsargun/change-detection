function m = meanKl2(numBin)
    % find the expected kl divergence between two distributions p, q
    % where q is uniform and p is uniform over the numBin-1 dimensional probability simplex
    q = ones(numBin,1)/numBin;
    it = 1e6;
    kl = zeros(it,1);
    for i = 1:it
        r = exprnd(ones(numBin,1));
        p = r/sum(r);
        llr = log(p./q);
        kl(i) = p'*llr;
    end
%     histogram(kl);
    m = mean(kl);
end