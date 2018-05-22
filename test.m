classdef test < handle
    % execute kl divergence, mean, lmp and glr tests simultaneously

    properties
        a % alphabet, in increasing order
        m % alphabet size
        n % sample size
        q % unchanged distribution
        r % changed distribution
        it % number of random realizations of r
        beta
        i_proj
        m_proj
        kl_p
        kl_test
        kl_perf % [probability of false alarm; worst case probability of detection;
        % average probability of detection]
        mean_p
        mean_test
        mean_perf
        lmp_p % [direction; threshold]
        lmp_test
        lmp_perf
        glr_p
        glr_test
        glr_perf
    end
    
    methods
        function obj = test(a,n,q,beta,kl_p,mean_p,lmp_p,glr_p)
            obj.a = a;
            obj.m = length(a);
            obj.n = n;
            obj.q = q;
            obj.beta = beta;
            obj.kl_p = kl_p;
            dummy = zeros(m,1);
            obj.kl_test = kl_div_test(d,q,beta,kl_p(1),kl_p(2));
            obj.mean_p = mean_p;
            obj.mean_test = mean_test(d,q,beta,mean_p);
            obj.lmp_p = lmp_p;
            obj.lmp_test = lmp_test(d,q,beta,lmp_p(1:end-1),lmp_p(end));
            obj.glr_p = glr_p;
            obj.glr_test = glr_test(d,q,beta,glr_p);
        end
        
        function p = un_random_dist(obj)
            p = rand(obj.m,1);
            p = p/sum(p);
        end
        
        function p = random_dist_mean(obj)
            mean = -inf;
            while mean < obj.beta
                p = obj.un_random_dist();
            end
            
        end
        
        function kl_pfa_test(obj)
            obj.kl_perf(1) = 0;
            for i = 1:obj.it
                if obj.kl_d(obj.dist(i,j,:),obj.proj) >= obj.kl_p(2)
                        obj.pfa = obj.pfa+obj.pfa_elem(obj.dist(i,j,:));
                end
                
            end
            
        end
        
        function d = mean(obj,p)
            d = obj.a'*p(:);
        end
        
    end
    
end