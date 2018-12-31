classdef pfaT
    % probability of false alarm test
    properties
        ex
        it
        method
        testName
        utility
    end
    
    methods
        function obj = pfaT(method)
            obj.method = method;
            obj.ex = obj.method.ex;
            obj.it = obj.method.it(1);
            obj.testName = 'pfaT';
            obj.utility = obj.method.utility;
        end
        
        function pfa = test(obj)
            if obj.it == 0
                return
            end
            
            % probability of false alarm
            numberOfFalseAlarms = 0;
            for i = 1:obj.it
                dist = obj.utility.realize(obj.ex.unchangedDist);
                numberOfFalseAlarms = numberOfFalseAlarms ...
                    +obj.method.is_change(dist);
            end
            
            pfa = numberOfFalseAlarms/obj.it;
        end
        
    end
    
end