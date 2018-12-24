classdef klT
    % Kullback Leibler distance test
    properties
        delayT
        ex
        iProj
        iProjSet
        klMean
        klMeanRange
        klRadius
        klRadiusRange
        mtbfT
        pdT
        pfaT
        testType
        utility
    end
    
    methods
        function obj = klT(experiment)
            obj.delayT = delayT();
            obj.ex = experiment;
            obj.klMeanRange = obj.ex.klMeanRange;
            obj.klRadiusRange = obj.ex.klRadiusRange;
            obj.mtbfT = mtbfT();
            obj.pdT = pdT();
            obj.pfaT = pfaT();
            % roc/perf test
            obj.testType = obj.ex.testType;
            obj.utility = obj.ex.utility;
            % cell of i projections, one per kl mean
            obj.iProjSet = obj.utility.i_proj(obj.ex.unchangedDist, ...
                obj.klMeanRange);
        end
        
        function run(obj)
            if strcmp(obj.testType,'roc')
                for i = 1:2
                    for j = 1:2
                        obj.pfaT.test(obj.ex,obj);
                        obj.pdT.test(obj.ex,obj);
                    end

                end
                
            elseif strcmp(obj.testType,'perf')
                for i = 1:2
                    for j = 1:2
                        obj.mtbfT.test(obj.ex,obj);
                        obj.delayT.test(obj.ex,obj);
                    end
                    
                end
                
            end
                    
        end
        
        function isChange = is_change(obj,dist)
            % decide change if mean and kl distance is above threshold
            % 0/1 output
            % do the i-projection only ONCE for each kl mean
            % obj.i_proj(obj.ex.unchangedDist, ...
            % obj.ex.klMeanRange(obj.ex.activeTestIndex{3}(1)));
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

