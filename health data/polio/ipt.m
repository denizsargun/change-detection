classdef ipt
    properties
        preMean % pre change mean of reported cases per million people
        numBin = 10;
        alph
        eps = 10;
        iniVac % initial vaccine coverage
        chnVac % definition of change in vaccine coverage
        edges
        thr;
    end
    
    methods
        function obj = ipt(iniVac,preMean)
            obj.iniVac = iniVac;
            obj.chnVac = obj.iniVac+obj.eps;
            obj.preMean = preMean(obj.iniVac);
            % DO EQUILIKELY BINNING HERE
            % obj.edges = ...;
            % obj.alph = ...;
            obj.thr = [MEANTHR;KLTHR];
        end
        
        function isChange(newSam)
            win = ;
            s = length(win);
            winMean = max(mean(win),0);
            if winMean > obj.thr(1)
                obj.iProj()
            end
            
        end

        function iProj(prjMean)
            ...
        end
        
        function d = klDiv(samples,projection)
            samples = floor(samples);
            
        end
        
    end
    
end