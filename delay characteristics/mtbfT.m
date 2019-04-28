classdef mtbfT
    % mean time between failures test
    properties
        ceil % max value for mtbf measured
        ex
        it
        method
        testName
        utility
    end
    
    methods
        function obj = mtbfT(method)
            obj.method = method;
            obj.ceil = 1e5;
            obj.ex = obj.method.ex;
            obj.it = obj.method.it(1);
            obj.testName = 'mtbfT';
            obj.utility = obj.method.utility;
        end
        
        function mtbf = test(obj)
            % mean time between failures
            totalTimeToFailure = 0;
            for i = 1:obj.it
                alarmTime = 0;
                detected = 0;
                while ~detected && alarmTime<obj.ceil
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