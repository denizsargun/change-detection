classdef lmpT
    % locally most powerful test
    properties
        delayT
        ex
        lmpDir
        lmpThr
        lmpThrRange
        mtbfT
        pdT
        pfaT
        testType
        utility
    end
    
    methods
        function obj = lmpT(experiment)
            obj.ex = experiment;
            obj.lmpThrRange = obj.ex.lmpThrRange;
            obj.lmpThr = obj.lmpThrRange(1);
            obj.pfaT = pfaT();
            obj.pdT = pdT();
            obj.mtbfT = mtbfT();
            obj.delayT = delayT();
            % set lmp direction
            % using i-projection of unchanged dist on
            % set of dists with mean >= beta
            obj.i_proj(obj.ex.unchangedDist,obj.ex.beta)
            obj.lmpDir = obj.ex.iProj-obj.ex.unchangedDist;
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
            d = obj.ex.sampleSize*dist' ...
                *log(obj.ex.iProj./obj.ex.unchangedDist) ...
                +log(dist'*(obj.ex.lmpDir./obj.ex.iProj));
            lmpThr = obj.ex.lmpThrRange(obj.ex.activeTestIndex{3});
            isChange = d >= lmpThr;
        end
        
    end
    
end

