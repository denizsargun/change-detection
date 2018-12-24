classdef delayT
    % detection delay test
    properties
        ex
        delayIt
        method
        utility
    end
    
    methods
        function obj = delayT(method)
            obj.method = method;
            obj.ex = obj.method.ex;
            obj.delayIt = obj.test.delayIt;
            obj.utility = obj.ex.utility;
        end
        
        function test(obj)
            for i = 1:obj.delayIt
                generateData
                alarm = min();
            end
            
        end
        
    end
end

