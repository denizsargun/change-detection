classdef glr_test < handle
    % generalized likelihoohd ratio test is executed
    properties
        test
        glrParam
    end
    
    methods
        function obj = glr_test(test)
            obj.test = test;
            obj.glrParam = test.glrParam;
        end
        
        function isChange = is_change(obj)
            
        end
        
    end
    
end

