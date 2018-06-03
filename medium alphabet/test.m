classdef test < handle
    % execute kl divergence, mean, lmp and glr tests simultaneously

    properties
        util % test toolbox
        a % alphabet, in ascending order
        m % alphabet size
        n % sample size
        dist % distribution of interest, depends on where it is called
        q % unchanged distribution
        r % changed distribution
        beta
        eps % allowed error in I-projection
        mProj % M-projection of \tilde{p}, the empirical dist
        klParam % kl div test parameters, [mean_param; radius_param] 
        klTest % kl div test object
        klPerf % [probability of false alarm; worst case probability of detection;
        % average probability of detection]
        meanParam
        meanTest
        meanPerf
        lmpParam % [direction; threshold]
        lmpTest
        lmpPerf
        glrParam
        glrTest
        glrPerf
        pfaIt % number of iterations for false alarm tests, [pfaItKlDivTest; pfaItMeanTest; pfaItLmpTest; pfaItGlrTest]
        it % number of random realizations of r    
    end
    
    methods
        function obj = test(a,n,q,beta,klParam,meanParam,lmpParam,glrParam)
            obj.a = sort(a);
            obj.m = length(obj.a);
            obj.n = n;
            obj.q = q;
            obj.beta = beta;
            obj.eps = min(abs(a-circshift(a,1)))/1e5;
            obj.klParam = klParam;
            obj.meanParam = meanParam;
            obj.lmpParam = lmpParam;
            obj.glrParam = glrParam;
            obj.util = util(obj);
            obj.klTest = kl_div_test(obj);
            obj.meanTest = mean_test(d,q,beta,meanParam);
            obj.lmpTest = lmp_test(d,q,beta,lmpParam(1:end-1),lmpParam(end));
            obj.glrTest = glr_test(d,q,beta,glrParam);
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
        
    end
        
end