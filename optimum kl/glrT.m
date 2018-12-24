classdef glrT
    % generalized likelihood ratio test
    properties
        delayT
        ex
        glrThr
        glrThrRange
        mtbfT
        pdT
        pfaT
        testType
        utility
    end
    
    methods
        function obj = glrT(experiment)
            obj.ex = experiment;
            obj.glrThrRange = obj.ex.glrThrRange;
            obj.glrThr = obj.glrThrRange(1);
            obj.pfaT = pfaT();
            obj.pdT = pdT();
            obj.mtbfT = mtbfT();
            obj.delayT = delayT();
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
            obj.m_proj(dist,obj.ex.beta)
            score = obj.emp_prob_calc(obj.ex.mProj,dist) ...
                /obj.emp_prob_calc(obj.ex.unchangedDist,dist);
            glrThr = obj.ex.glrThrRange(obj.ex.activeTestIndex{3});
            isChange = score >= glrThr;
        end
        
    end
    
end

