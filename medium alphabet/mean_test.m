classdef mean_test < handle
    % execute mean test
    properties
        test % test object
        meanParam
    end
    
    methods
        function obj = mean_test(test)
            obj.test = test;
            obj.meanParam = test.meanParam;
        end
        
        function isChange = is_change(obj,dist)
            isChange = obj.test.util.mean(dist) >= obj.meanParam;
        end
        
    end
    
end

