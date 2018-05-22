classdef test < handle
    % execute kl divergence, mean, lmp and glr tests simultaneously

    properties
        a % alphabet, in increasing order
        m % alphabet size
        n % sample size
        q % unchanged distribution
        check_q % utility to realize q
        emp_dist_orig % empirical dist under original dist
        real_prob_orig % probability of realizing empirical dist from original dist
        r % changed distribution
        it % number of random realizations of r
        beta
        i_proj % I-projection of q
        eps % allowed error in projection
        m_proj % M-projection of \tilde{p}, the empirical dist
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
            obj.eps = min(abs(a-circshift(a,1)))/1e5;
            obj.m = length(a);
            obj.n = n;
            obj.q = q;
            obj.beta = beta;
            obj.i_project();
            obj.kl_p = kl_p;
            dummy = zeros(m,1);
            obj.kl_test = kl_div_test(d,q,beta,kl_p(1),kl_p(2));
            obj.mean_p = mean_p;
            obj.mean_test = mean_test(d,q,beta,mean_p);
            obj.lmp_p = lmp_p;
            obj.lmp_test = lmp_test(d,q,beta,lmp_p(1:end-1),lmp_p(end));
            obj.glr_p = glr_p;
            obj.glr_test = glr_test(d,q,beta,glr_p);
            str_lower_tri = tril(ones(obj.m),-1);
            obj.check_q = str_lower_tri*obj.q*ones(1,n);
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
        
        function pick_change_random(obj)
            obj.r = obj.random_dist_mean;
        end
        
        function realize_q(obj)
            seed = rand(obj.n,1);
            seed_m = ones(obj.m,1)*seed'; % concatenated matrix
            real_index = sum(seed_m >= obj.check_q);
            real = obj.a(real_index); % sequence of realizations, unused
            emp_ccdf = sum(seed_m >= obj.check_q,2)/obj.n; % like ccdf
            obj.emp_dist_orig = emp_ccdf-[emp_ccdf(2:end); 0];
            obj.real_prob_orig = obj.emp_prob_calc(obj.q,obj.emp_dist_orig,obj.n);
        end
        
        function kl_pfa_test(obj)
            obj.kl_perf(1) = 0;
            for i = 1:obj.it
                obj.realize_q();
                if obj.kl_d(obj.emp_dist_orig,obj.i_proj) >= obj.kl_p(2)
                    obj.kl_perf(1) = obj.kl_perf(1)+obj.real_prob_orig;
                end
                
            end
            
            obj.kl_perf(1) = obj.kl_perf(1)/obj.it;
        end
        
        function d = mean(obj,p)
            d = obj.a'*p(:);
        end
        
        function i_project(obj)
            obj.i_proj = obj.q;
            err = (obj.kl_p(1)-obj.mean(obj.i_proj))*inf;
            while abs(err)>obj.eps
                obj.i_proj = obj.i_proj.*exp(sign(err)*obj.eps*obj.a);
                obj.i_proj = obj.i_proj/sum(obj.i_proj);
                err = obj.kl_p(1)-obj.mean(obj.i_proj);
            end
            
        end        
        
    end
    
    methods (Static)
        function d = kl_d(p,q) % base e
            d = 0;
            for i = 1:length(p)
                if p(i) > 0
                    d = d+p(i)*log(p(i)/q(i));
                end
                
            end
            
        end
        
        function d = emp_prob_calc(p_orig,p_tilde,n)
            % calculate the probability of observing p_tilde from p_orig in
            % n trials
            d2 = zeros(n,1);
            d3 = n*tril(ones(n),-1)*p_tilde;
            for i = 1:length(p_tilde)
                d2(round(d3(i))+1:round(d3(i+1))) = 1:round(n*p_tilde(i)); % debugging rounding error by round()
            end
            
            d = prod((1:n)'./d2); % multinomial coefficient
            d = d*prod(p_orig.^(n*p_tilde));
        end
        
    end
    
end