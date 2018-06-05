classdef kl_test < handle
    % KL divergence based detection test is executed
    properties
        test % test object
        klMean % mean threshold
        klRadius % KL divergence threshold
    end
    
    methods
        function obj = kl_test(test)
            obj.test = test;
            obj.klMean = test.klParam(1);
            obj.klRadius = test.klParam(2);
            test.util.i_proj(obj.test.q,obj.klMean); % set iProj
        end
        
        function isChange = is_change(obj,dist)
            % decide change if mean and kl distance is above threshold, 0/1
            % output
            meanChange = obj.test.util.mean(dist) >= obj.klMean;
            klChange = obj.test.util.kl_d(dist,obj.test.iProj) >= obj.klRadius;
            isChange = and(meanChange,klChange);
        end
        
        function klChange = kl_change(obj,dist)
            % decide whether kl distance is above threshold, 0/1 output
            klChange = obj.test.util.kl_d(dist,obj.test.iProj) >= obj.klRadius;
        end
        
    end
    
end