classdef meanT
    % mean test
    properties
        delayT
        ex
        meanMean
        meanMeanRange
        mtbfT
        pdT
        pfaT
        testType
        utility
    end
    
    methods
        function obj = meanT(experiment)
            obj.delayT = delayT();
            obj.ex = experiment;
            obj.meanMeanRange = obj.ex.meanMeanRange;
            obj.mtbfT = mtbfT();
            obj.pfaT = pfaT();
            obj.pdT = pdT();
            % roc/perf test
            obj.testType = obj.ex.testType;
            obj.utility = obj.ex.utility;
        end
        
        function run(obj)
            if obj.testType = 'roc'
                for i = 1:2
                    obj.pfaT.test(obj.ex,obj);
                    obj.pdT.test(obj.ex,obj);
                end
                
            elseif obj.testType = 'perf'
                for i = 1:2
                    obj.mtbfT.test(obj.ex,obj);
                    obj.delayT.test(obj.ex,obj);
                end
                
            end
            
        end
        
        function isChange = is_change(obj,dist)
            meanMean = obj.ex.meanMeanRange(obj.ex.activeTestIndex{3});
            isChange = obj.mean(dist) >= meanMean;
        end
        
    end
    
end

