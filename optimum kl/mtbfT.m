classdef mtbfT
    % mean time between failures test
    properties
        ex
        it
        method
        testName
        utility
    end
    
    methods
        function obj = mtbfT(method)
            obj.method = method;
            obj.ex = obj.method.ex;
            obj.it = obj.method.it(3);
            obj.testName = 'mtbfT';
            obj.utility = obj.method.utility;
        end
        
        function mtbf = test(obj)
            if obj.it == 0
                mtbf = -1;
                return
            end
            
            % mean time between failures
            totalTimeToFailure = 0;
            for i = 1:obj.it
                alarmTime = 0;
                detected = 0;
                while ~detected
                    dist = obj.utility.realize(obj.ex.unchangedDist);
                    alarmTime = alarmTime+obj.ex.sampleSize;
                    detected = obj.method.is_change(dist);
                end
                
                totalTimeToFailure = totalTimeToFailure+alarmTime;
            end
            
            mtbf = totalTimeToFailure/obj.it;
        end
        
    end
    
end