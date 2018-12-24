classdef mtbfT
    % mean time between failures test
    properties
        ex
        method
        mtbfIt
        utility
    end
    
    methods
        function obj = mtbfT(method)
            obj.method = method;
            obj.ex = obj.method.ex;
            obj.mtbfIt = obj.test.mtbfIt;
            obj.utility = obj.ex.utility;
        end
        
        function test(obj)
            for i = 1:obj.mtbfIt
                generateData
                alarm = min();
            end
            
        end
        
    end
end

