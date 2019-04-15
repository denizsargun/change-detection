% initialize the quantized distributions
% quantize N(0,1) and N(0,epsilon)
% using 2^{n+1} bins from -2^n to 2^n
epsilon = 0.1;
m = 5;
nRange = 2.^(1:m);
dist = cell(5,1);
for i = 1:m
    n = nRange(i);
    partition = (-n:1/n:n)';
    q = normcdf(partition(2:end))-normcdf(partition(1:end-1));
    q = q/sum(q);
    codebook = (-n+1/(2*n):1/n:n-1/(2*n))';
    dist{m} = q;
end