classdef lmpM
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
        method
        mtbfT
        pdT
        pfaT
        utility
    end
    
    methods
        function obj = lmpM(experiment)
            obj.ex = experiment;
            % eps = min abs difference among alphabet letters/1e5
            obj.eps = min(abs(obj.ex.alphabet- ...
                circshift(obj.ex.alphabet,1)))/1e6;
            obj.lmpThrRange = obj.ex.lmpThrRange;
            obj.lmpThr = obj.lmpThrRange(1);
            obj.method = 'lmpM';
            obj.pfaT = pfaT(obj);
            obj.pdT = pdT(obj);
            obj.mtbfT = mtbfT(obj);
            obj.delayT = delayT(obj);
            % set lmp direction
            % using i-projection of unchanged dist on
            % set of dists with mean >= beta
            obj.utility.i_proj(obj.ex.unchangedDist,obj.ex.beta,obj.eps)
            obj.lmpDir = obj.iProj-obj.ex.unchangedDist;
        end
        
        function isChange = is_change(obj,dist)
            d = obj.ex.sampleSize*dist' ...
                *log(obj.iProj./obj.ex.unchangedDist) ...
                +log(dist'*(obj.ex.lmpDir./obj.iProj));
            lmpThr = obj.ex.lmpThrRange();
            isChange = d >= lmpThr;
        end
        
    end
    
end

