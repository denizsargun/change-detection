classdef meanM < handle
    % mean test
    properties
        ex
        it
        meanMean
        meanMeanRange
        methodName
        numberOfSettings
        timeT
        util
    end
    
    methods
        function obj = meanM(experiment)
            obj.ex = experiment;
            obj.it = obj.ex.it(2,:);
            obj.meanMeanRange = obj.ex.meanMeanRange;
            obj.meanMean = obj.meanMeanRange(1);
            obj.methodName = 'meanM';
            obj.numberOfSettings = length(obj.meanMeanRange);
            obj.util = obj.ex.util;
            % tests need ex and utility objects
            obj.timeT = timeT(obj);
        end
        
        function [isChange, time] = is_change(obj,dist)
            tic
            isChange = obj.util.mean(dist) >= obj.meanMean;
            time = toc;
        end
        
        function update(obj)
            index = find(obj.meanMean == obj.meanMeanRange);
            obj.meanMean = obj.meanMeanRange(index+1);
        end
        
    end
    
end