classdef meanM
    % mean test
    properties
        delayT
        ex
        it
        meanMean
        meanMeanRange
        method
        mtbfT
        pdT
        pfaT
        utility
    end
    
    methods
        function obj = meanM(experiment)
            obj.delayT = delayT(obj);
            obj.ex = experiment;
            obj.meanMeanRange = obj.ex.meanMeanRange;
            obj.method = 'meanM';
            obj.mtbfT = mtbfT(obj);
            obj.pfaT = pfaT(obj);
            obj.pdT = pdT(obj);
            obj.utility = obj.ex.utility;
        end
        
        function isChange = is_change(obj,dist)
            meanMean = obj.ex.meanMeanRange();
            isChange = obj.mean(dist) >= meanMean;
        end
        
    end
    
end

