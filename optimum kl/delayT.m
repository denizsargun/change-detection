classdef delayT
    % detection delay test
    properties
        changedDist
        ex
        it
        method
        testName
        utility
    end
    
    methods
        function obj = delayT(method)
            obj.method = method;
            obj.ex = obj.method.ex;
            obj.it = obj.method.it(4);
            obj.testName = 'delayT';
            obj.utility = obj.method.utility;
        end
        
        function delay = test(obj)
            if obj.it == 0
                delay = -1;
                return
            end
            
            % delay
            totalDelay = 0;
            for i = 1:obj.it
                alarmTime = 0;
                detected = 0;
                obj.changedDist = ...
                    obj.utility.random_dist_mean(obj.ex.beta);
                while ~detected
                    dist = obj.utility.realize(obj.changedDist);
                    alarmTime = alarmTime+obj.ex.sampleSize;
                    detected = obj.method.is_change(dist);
                end
                
                totalDelay = totalDelay+alarmTime;
            end
            
            delay = totalDelay/obj.it;
        end
        
    end
    
end