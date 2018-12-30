classdef mtbfT
    % mean time between failures test
    properties
        ex
        it
        method
        utility
    end
    
    methods
        function obj = mtbfT(method)
            obj.method = method;
            obj.ex = obj.method.ex;
            obj.utility = obj.ex.utility;
        end
        
        function test(obj)
            % mean time between failures
            for i = 1:obj.it
                alarmTime = 0;
                while ~detected
                    dist = obj.utility.realize(obj.ex.unchangedDist);
                    alarmTime = alarmTime+obj.ex.sampleSize;
                    detected = obj.method.is_change(dist);
                end
                
            end
            
        end
        
    end
end

