classdef lmp_test < handle
    % locally most powerful test is executed
    properties
        test % test object
        lmpDir % test direction
        lmpThr % threshold
    end
    
    methods
        function obj = lmp_test(test)
            obj.test = test;
            obj.lmpDir = test.lmpParam(1:end-1);
            obj.lmpThr = test.lmpParam(end);
            test.util.i_proj(obj.test.q,obj.test.beta); % set iProj
        end
        
        function isChange = is_change(obj,dist)
            d = obj.test.n*dist'*log(obj.test.iProj./obj.test.q)+log(dist'*(obj.lmpDir./obj.test.iProj));
            isChange = d >= obj.lmpThr;
        end
        
    end
    
end