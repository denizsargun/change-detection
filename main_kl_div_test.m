clear
clc
p = prob_simplex();
q = [1/3;1/3;1/3];
beta = 1/4;
mean_th = (0:0.1:1)';
kl_radius = 2.^(-10:1:0);
dim = [length(mean_th) length(kl_radius)];
pfa = zeros(dim);
pd_wc = zeros(dim);
pd_av = zeros(dim);
for i = 1:dim(1)
    for j = 1:dim(2)
        k = kl_div_test(p,q,beta,mean_th(i),kl_radius(j));
        k.pfa_test()
        k.pd_test_av()
        k.pd_test_wc()
        pfa(i,j) = k.pfa;
        pd_wc(i,j) = k.pd_wc;
        pd_av(i,j) = k.pd_av;
        [i,j]
    end
    
end