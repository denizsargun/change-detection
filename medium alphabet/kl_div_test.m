classdef kl_div_test < handle
    % KL divergence based detection test is executed
    properties
        test
        util
        dist
        q % unchanged distribution
        i_proj % I-projection
        mean_param % mean threshold
        radius_param % KL divergence threshold
    end
    
    methods
        function obj = kl_div_test(test)
            obj.test = test;
            obj.util = test.util;
            obj.dist = test.dist;
            obj.q = test.q;
            obj.mean_param = test.kl_param(1);
            obj.radius_param = test.kl_param(2);
            obj.i_proj = util.i_proj(obj.q,mean_param);
        end
        
        function isChange = is_change(obj)
            % decide change if mean and kl distance is above threshold
            meanChange = obj.util.mean(obj.dist) >= obj.mean_param;
            klChange = obj.util.kl_d(obj.dist,obj.i_proj) >= obj.radius_param;
            isChange = and(meanChange,klChange);
        end
        
        function klChange = kl_change(obj)
            % decide whether kl distance is above threshold
            klChange = obj.util.kl_d(obj.dist,obj.i_proj) >= obj.radius_param;
        end
        
    end
    
end