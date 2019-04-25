classdef glrM < handle
    % generalized likelihood ratio test
    properties
        ex
        glrThr
        glrThrRange
        it
        methodName
        mProj
        numberOfSettings
        timeT
        util
    end
    
    methods
        function obj = glrM(experiment)
            obj.ex = experiment;
            obj.glrThrRange = obj.ex.glrThrRange;
            obj.glrThr = obj.glrThrRange(1);
            obj.it = obj.ex.it(3,:);
            obj.methodName = 'glrM';
            obj.numberOfSettings = length(obj.glrThrRange);
            obj.util = obj.ex.util;
            obj.timeT = timeT(obj);
        end
        
        function [isChange, time] = is_change(obj,dist)
            tic
            % obj.mProj = obj.util.m_proj(dist,obj.ex.beta);
            obj.mProj = obj.util.m_proj_NEW(dist,obj.ex.beta);
            score = obj.util.emp_prob_calc(obj.mProj,dist) ...
                /obj.util.emp_prob_calc(obj.ex.unchangedDist,dist);
            isChange = score >= obj.glrThr;
            time = toc;
        end
        
        function update(obj)
            index = find(obj.glrThr == obj.glrThrRange);
            obj.glrThr = obj.glrThrRange(index+1);
        end
        
    end
    
end