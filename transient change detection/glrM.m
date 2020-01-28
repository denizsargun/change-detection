classdef glrM < handle
    properties
        dGau % discrete Gaussian sampler
        noCo % normalization constant class
        test
        wndw % window length
    end
    
    methods
        function obj = glrM(test)
            obj.test = test;
            obj.dGau = obj.test.dGau;
            obj.noCo = obj.dGau.noCo;
            obj.wndw = obj.test.dura;
        end
        
        function isAl = isAl(obj,timS)
            estm = obj.estm(timS);
            nDGa = dGau()
        end
        
        function estm = estm(obj,timS)
            % estimate the post-change parameter via maximum likelihood
            
        end
        
    end
    
end