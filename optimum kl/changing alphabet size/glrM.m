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
        timeT
        utility
    end
    
    methods
        function obj = glrM(experiment)
            obj.ex = experiment;
            obj.glrThrRange = obj.ex.glrThrRange;
            obj.glrThr = obj.glrThrRange(1);
            obj.it = obj.ex.it(4,:);
            obj.methodName = 'glrM';
            obj.numberOfSettings = length(obj.glrThrRange);
            obj.utility = obj.ex.utility;
            obj.delayT = delayT(obj);
            obj.mtbfT = mtbfT(obj);
            obj.pdT = pdT(obj);
            obj.pfaT = pfaT(obj);
            obj.timeT = timeT(obj);
        end
        
        function [isChange, time] = is_change(obj,dist)
            tic
            % obj.mProj = obj.utility.m_proj(dist,obj.ex.beta);
            obj.mProj = obj.utility.m_proj_NEW(dist,obj.ex.beta);
            score = obj.utility.emp_prob_calc(obj.mProj,dist) ...
                /obj.utility.emp_prob_calc(obj.ex.unchangedDist,dist);
            isChange = score >= obj.glrThr;
            time = toc;
        end
        
        function update(obj)
            index = find(obj.glrThr == obj.glrThrRange);
            obj.glrThr = obj.glrThrRange(index+1);
        end
        
    end
    
end