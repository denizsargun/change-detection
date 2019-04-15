classdef lmpM < handle
    % locally most powerful test
    properties
        delayT
        eps
        ex
        iProj
        it
        lmpDir
        lmpThr
        lmpThrRange
        methodName
        numberOfSettings
        mtbfT
        pdT
        pfaT
        timeT
        utility
    end
    
    methods
        function obj = lmpM(experiment)
            obj.ex = experiment;
            % eps = min abs difference among alphabet letters/1e5
            obj.eps = min(abs(obj.ex.alphabet- ...
                circshift(obj.ex.alphabet,1)))/1e6;
            obj.it = obj.ex.it(3,:);
            obj.lmpThrRange = obj.ex.lmpThrRange;
            obj.lmpThr = obj.lmpThrRange(1);
            obj.methodName = 'lmpM';
            obj.numberOfSettings = length(obj.lmpThrRange);
            obj.utility = obj.ex.utility;
            obj.delayT = delayT(obj);
            obj.mtbfT = mtbfT(obj);
            obj.pdT = pdT(obj);
            obj.pfaT = pfaT(obj);
            obj.timeT = timeT(obj);
            % set lmp direction
            % using i-projection of preChange on
            % set of dists with mean >= beta
            iProjCell = obj.utility.i_proj(obj.ex.preChange, ...
                obj.ex.beta,obj.eps);
            obj.iProj = iProjCell{1};
            obj.lmpDir = obj.iProj-obj.ex.preChange;
        end
        
        function isChange = is_change(obj,dist)
            score = obj.ex.sampleSize*dist' ...
                *log(obj.iProj./obj.ex.preChange) ...
                +log(dist'*(obj.lmpDir./obj.iProj));
            isChange = score >= obj.lmpThr;
        end
        
        function update(obj)
            index = find(obj.lmpThr == obj.lmpThrRange);
            obj.lmpThr = obj.lmpThrRange(index+1);
        end
        
    end
    
end