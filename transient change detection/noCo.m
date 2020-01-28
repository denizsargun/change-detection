classdef noCo < handle
    properties
        alph % alphabet
    end
    
    methods
        function obj = noCo(dGau)
            obj.alph = dGau.alph;
        end
        
        function cons = getC(obj,varn)
            pdVc = exp(-obj.alph.^2/(2*varn));
            cons = 1/sum(pdVc);
        end
        
    end
    
end