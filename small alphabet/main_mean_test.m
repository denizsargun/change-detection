clear
clc
p = prob_simplex();
q = [1/3;1/3;1/3];
beta = 1/4;
mean_th = (0:0.1:1)';
dim = length(mean_th);
pfa = zeros(dim,1);
pd_wc = zeros(dim,1);
pd_av = zeros(dim,1);
for i = 1:dim(1)
    m = mean_test(p,q,beta,mean_th(i));
    m.pfa_test()
    m.pd_test_av()
    m.pd_test_wc()
    pfa(i) = m.pfa;
    pd_wc(i) = m.pd_wc;
    pd_av(i) = m.pd_av;
    i
end
