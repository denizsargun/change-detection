classdef pdT
    % probability of detection test
    properties
        ex
        method
        pdIt
        utility
    end
    
    methods
        function obj = pdT(method)
            obj.method = method;
            obj.ex = obj.method.ex;
            obj.pdIt = obj.test.pdIt;
            obj.utility = obj.ex.utility;
        end
        
        function test(obj)
            for i = 1:obj.pdIt
                generateData
                obj.method.is_change(dist)
            end
            
        end
        
    end
end

