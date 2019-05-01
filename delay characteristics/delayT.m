classdef delayT
    % worst case detection delay test
    properties
        changedDist
        ex
        it
        method
        testName
        timeCeil % max value for delay measured
        utility
    end
    
    methods
        function obj = delayT(method)
            obj.method = method;
            obj.ex = obj.method.ex;
            obj.it = obj.method.it(2);
            obj.testName = 'delayT';
            obj.timeCeil = 1e5;
            obj.utility = obj.method.utility;
        end
        
        function worstDelay = test(obj)
            % delay for worst distribution
            numberOfDists = 10^ceil(log10(obj.it)/2);
            testsPerDist = 10^floor(log10(obj.it)/2);
            worstDelay = 0;
            for i = 1:numberOfDists
                worstDelay = max(worstDelay,obj.singleTest(testsPerDist));
            end
            
        end
        
        function delaySingleDist = singleTest(obj,it)
            % delay given a post change distribution
            totalDelay = 0;
            obj.changedDist = ...
                obj.utility.random_dist_mean_NEW(obj.ex.beta);
            for i = 1:it
                alarmTime = 0;
                detected = 0;
                while ~detected && alarmTime<obj.timeCeil
                    dist = obj.utility.realize(obj.changedDist);
                    alarmTime = alarmTime+obj.ex.sampleSize;
                    detected = obj.method.is_change(dist);
                end
                
                totalDelay = totalDelay+alarmTime;
            end
            
            delaySingleDist = totalDelay/it;
        end
        
    end
    
end