classdef glr_test < handle
    % generalized likelihoohd ratio test is executed
    properties
        test
        glrParam % glrParam can be <= 1 because we consider the constrained projection,
        % ie. mean(mProj) <= beta
    end
    
    methods
        function obj = glr_test(test)
            obj.test = test;
            obj.glrParam = test.glrParam;
        end
        
        function isChange = is_change(obj,dist)
            obj.test.util.m_proj(dist,obj.test.beta)
            score = obj.test.util.emp_prob_calc(obj.test.mProj,dist)/obj.test.util.emp_prob_calc(obj.test.q,dist);
            isChange = score >= obj.glrParam;
        end
        
    end
    
end