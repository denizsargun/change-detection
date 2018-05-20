clear
clc
p = prob_simplex();
q = [1/3;1/3;1/3];
beta = 1/4;
dir = [0; 0; 0]; % dummy direction
th = (-10:10)';
dim = length(th);
pfa = zeros(dim,1);
pd_wc = zeros(dim,1);
pd_av = zeros(dim,1);
for i = 1:dim(1)
    lm = lmp_test(p,q,beta,dir,th(i));
    dirc = lm.proj-lm.q;
    lm.lmp_p(1:end-1) = dirc/norm(dirc);
    lm.pfa_test()
    lm.pd_test_av()
    lm.pd_test_wc()
    pfa(i) = lm.pfa;
    pd_wc(i) = lm.pd_wc;
    pd_av(i) = lm.pd_av;
    i
end