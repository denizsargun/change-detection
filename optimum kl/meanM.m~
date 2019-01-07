classdef meanM < handle
    % mean test
    properties
        delayT
        ex
        it
        meanMean
        meanMeanRange
        methodName
        mtbfT
        numberOfSettings
        pdT
        pfaT
        timeT
        utility
    end
    
    methods
        function obj = meanM(experiment)
            obj.ex = experiment;
            obj.it = obj.ex.it(2,:);
            obj.meanMeanRange = obj.ex.meanMeanRange;
            obj.meanMean = obj.meanMeanRange(1);
            obj.methodName = 'meanM';
            obj.numberOfSettings = length(obj.meanMeanRange);
            obj.utility = obj.ex.utility;
            % tests need ex and utility objects
            obj.delayT = delayT(obj);
            obj.mtbfT = mtbfT(obj);
            obj.pdT = pdT(obj);
            obj.pfaT = pfaT(obj);
            obj.timeT = timeT(obj);
        end
        
        function isChange = is_change(obj,dist)
            isChange = obj.utility.mean(dist) >= obj.meanMean;
        end
        
        function update(obj)
            index = find(obj.meanMean == obj.meanMeanRange);
            obj.meanMean = obj.meanMeanRange(index+1);
        end
        
    end
    
end