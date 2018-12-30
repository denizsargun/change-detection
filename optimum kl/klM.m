classdef klM
    % Kullback Leibler distance test
    properties
        delayT
        eps
        ex
        iProj
        iProjSet
        it
        klMean
        klMeanRange
        klRadius
        klRadiusRange
        method
        mtbfT
        pdT
        pfaT
        utility
    end
    
    methods
        function obj = klM(experiment)
            obj.delayT = delayT(obj);
            obj.ex = experiment;
            % eps = min abs difference among alphabet letters/1e5
            obj.eps = min(abs(obj.ex.alphabet- ...
                circshift(obj.ex.alphabet,1)))/1e5;
            obj.klMeanRange = obj.ex.klMeanRange;
            obj.klRadiusRange = obj.ex.klRadiusRange;
            obj.method = 'klM';
            obj.mtbfT = mtbfT(obj);
            obj.pdT = pdT(obj);
            obj.pfaT = pfaT(obj);
            obj.utility = obj.ex.utility;
            % cell of i projections, one per kl mean
            obj.iProjSet = obj.utility.i_proj(obj.ex.unchangedDist, ...
                obj.klMeanRange,obj.eps);
            run(obj)
        end
        
        function isChange = is_change(obj,dist)
            % decide change if mean and kl distance is above threshold
            % 0/1 output
            meanChange = obj.mean_change(dist);
            klChange = obj.kl_change(dist);
            isChange = and(meanChange,klChange);
        end
        
        function meanChange = mean_change(obj,dist)
            % decide whether the change in mean is above threshold
            % 0/1 output
            meanChange = obj.mean(dist) >= obj.klMean;
        end
        
        function klChange = kl_change(obj,dist)
            % decide whether kl distance is above threshold, 0/1 output
            klChange = obj.kl_distance(dist,obj.iProj) >= obj.klRadius;
        end
        
    end
    
end

