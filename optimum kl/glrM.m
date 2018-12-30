classdef glrM
    % generalized likelihood ratio test
    properties
        delayT
        ex
        glrThr
        glrThrRange
        it
        method
        mProj
        mtbfT
        pdT
        pfaT
        utility
    end
    
    methods
        function obj = glrM(experiment)
            obj.ex = experiment;
            obj.glrThrRange = obj.ex.glrThrRange;
            obj.glrThr = obj.glrThrRange(1);
            obj.method = 'glrM';
            obj.pfaT = pfaT(obj);
            obj.pdT = pdT(obj);
            obj.mtbfT = mtbfT(obj);
            obj.delayT = delayT(obj);
        end
        
        function isChange = is_change(obj,dist)
            obj.mProj = obj.utility.m_proj(dist,obj.ex.beta);
            score = obj.utility.emp_prob_calc(obj.mProj,dist) ...
                /obj.emp_prob_calc(obj.ex.unchangedDist,dist);
            glrThr = obj.ex.glrThrRange();
            isChange = score >= glrThr;
        end
        
    end
    
end

