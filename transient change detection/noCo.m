classdef noCo < handle
    % normalization constant
    properties
        alph % alphabet
    end
    
    methods
        function obj = noCo(dGau)
            obj.alph = dGau.alph;
        end
        
        function cons = getC(obj,thet)
            pdVc = exp(-obj.alph.^2/(2*thet));
            cons = 1/sum(pdVc);
        end
        
    end
    
end