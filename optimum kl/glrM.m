classdef glrM < handle
    % generalized likelihood ratio test
    properties
        delayT
        ex
        glrThr
        glrThrRange
        it
        methodName
        mProj
        mtbfT
        numberOfSettings
        pdT
        pfaT
        utility
    end
    
    methods
        function obj = glrM(experiment)
            obj.ex = experiment;
            obj.glrThrRange = obj.ex.glrThrRange;
            obj.glrThr = obj.glrThrRange(1);
            obj.methodName = 'glrM';
            obj.numberOfSettings = length(glrThrRange);
            obj.delayT = delayT(obj);
            obj.mtbfT = mtbfT(obj);
            obj.pdT = pdT(obj);
            obj.pfaT = pfaT(obj);
        end
        
        function isChange = is_change(obj,dist)
            obj.mProj = obj.utility.m_proj(dist,obj.ex.beta);
            score = obj.utility.emp_prob_calc(obj.mProj,dist) ...
                /obj.emp_prob_calc(obj.ex.unchangedDist,dist);
            isChange = score >= obj.glrThr;
        end
        
        function update(obj)
            index = find(obj.glrThr == obj.glrThrRange);
            obj.glrThr = obj.glrThrRange(index+1);
        end
        
    end
    
end