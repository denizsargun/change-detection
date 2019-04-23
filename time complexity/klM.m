classdef klM < handle
    % Kullback Leibler distance test
    properties
        delayT
        eps
        ex
        iProj
        iProjCell
        it
        klMean
        klMeanRange
        klRadius
        klRadiusRange
        methodName
        mtbfT
        numberOfSettings
        pdT
        pfaT
        timeT
        utility
    end
    
    methods
        function obj = klM(experiment)
            obj.ex = experiment;
            % eps = min abs difference among alphabet letters/1e5
            obj.eps = min(abs(obj.ex.alphabet- ...
                circshift(obj.ex.alphabet,1)))/1e5;
            obj.it = obj.ex.it(1,:);
            obj.klMeanRange = obj.ex.klMeanRange;
            obj.klMean = obj.klMeanRange(1);
            obj.klRadiusRange = obj.ex.klRadiusRange;
            obj.klRadius = obj.klRadiusRange(1);
            obj.methodName = 'klM';
            obj.numberOfSettings = length(obj.klMeanRange) ...
                *length(obj.klRadiusRange);
            obj.utility = obj.ex.utility;
            % cell of i projections, one per kl mean
            obj.iProjCell = obj.utility.i_proj(obj.ex.unchangedDist, ...
                obj.klMeanRange,obj.eps);
            obj.iProj = obj.iProjCell{1};
            % tests need ex and utility objects
            obj.delayT = delayT(obj);
            obj.mtbfT = mtbfT(obj);
            obj.pdT = pdT(obj);
            obj.pfaT = pfaT(obj);
            obj.timeT = timeT(obj);
        end
        
        function isChange = is_change(obj,dist)
            % decide change if mean and kl distance is above threshold
            % 0/1 output
            isChange = 0;
            meanChange = obj.mean_change(dist);
            if meanChange
                klChange = obj.kl_change(dist);
                isChange = klChange;
            end
            
        end
        
        function meanChange = mean_change(obj,dist)
            % decide whether the change in mean is above threshold
            % 0/1 output
            meanChange = obj.utility.mean(dist) >= obj.klMean;
        end
        
        function klChange = kl_change(obj,dist)
            % decide whether kl distance is above threshold, 0/1 output
            klChange = obj.utility.kl_distance(dist,obj.iProj) ...
                >= obj.klRadius;
        end
        
        function update(obj)
            if obj.klRadius ~= obj.klRadiusRange(end)
                klRadiusIndex = find(obj.klRadius == obj.klRadiusRange);
                obj.klRadius = obj.klRadiusRange(klRadiusIndex+1);
            else
                klMeanIndex = find(obj.klMean == obj.klMeanRange);
                obj.klRadius = obj.klRadiusRange(1);
                obj.klMean = obj.klMeanRange(klMeanIndex+1);
                obj.iProj = obj.iProjCell{klMeanIndex+1};
            end
            
        end
        
    end
    
end