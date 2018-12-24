classdef pfaT
    % probability of false alarm test
    properties
        ex
        method
        pfaIt
        utility
    end
    
    methods
        function obj = pfaT(method)
            obj.method = method;
            obj.ex = obj.method.ex;
            obj.pfaIt = obj.test.pfaIt;
            obj.utility = obj.ex.utility;
        end
        
        function test(obj)
            % probability of false alarm
            numberOfFalseAlarms = 0;
            for i = 1:obj.pfaIt
                dist = obj.utility.realize(obj.ex.unchangedDist);
                numberOfFalseAlarms = numberOfFalseAlarms ...
                    +obj.method.is_change(dist);
            end
               
        end
        
    end
end

