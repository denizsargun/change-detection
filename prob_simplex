classdef prob_simplex < handle
    % PROB_SIMPLEX define a simple probability simplex
    % alphabet is fixed, sample size is fixed
    
    properties
        a = [-1;0;1]
        n = 50
        dist
        is_dist
        q
        beta
        kl_p
        mean_p
        lmp_p
        glr_p
    end
    
    methods
        function obj = prob_simplex()
            step = 1/obj.n;
            d = (0:step:1)'; % dummy vector
            d2 = d*ones(1,obj.n+1);
            obj.dist = cat(3,d2,d2',1-d2-d2');
            obj.is_dist = (d2+d2'<= 1);
        end
        
        %function see_simplex(obj)
        
        %end
        
        %function color_simplex(obj)
        
        %end
        
    end
    
end
