clear
clc
p = prob_simplex();
q = [1/3;1/3;1/3];
beta = 1/4;
th = 2.^(-10)';
dim = length(th);
pfa = zeros(dim,1);
pd_wc = zeros(dim,1);
pd_av = zeros(dim,1);
for i = 1:dim(1)
    gl = glr_test(p,q,beta,th(i));
    gl.pfa_test()
    fprintf('pfa')
    gl.pd_test_av_and_wc()
    pfa(i) = gl.pfa;
    pd_wc(i) = gl.pd_wc;
    pd_av(i) = gl.pd_av;
    i
end
