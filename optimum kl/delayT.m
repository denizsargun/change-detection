classdef delayT
    % detection delay test
    properties
        changedDist
        ex
        it
        method
        utility
    end
    
    methods
        function obj = delayT(method)
            obj.method = method;
            obj.ex = obj.method.ex;
            obj.utility = obj.ex.utility;
        end
        
        function test(obj)
            % delay
            for i = 1:obj.it
                alarmTime = 0;
                obj.changedDist = ...
                    obj.utility.random_dist_mean(obj.ex.beta);
                while ~detected
                    dist = obj.utility.realize(obj.changedDist);
                    alarmTime = alarmTime+obj.ex.sampleSize;
                    detected = obj.method.is_change(dist);
                    obj.changedDist = ...
                        obj.utility.random_dist_mean(obj.ex.beta);
                end
                
            end
            
        end
        
    end
end

