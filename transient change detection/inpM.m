classdef inpM < handle
    properties
        dGau % discrete Gaussian sampler
        test
        wndw
    end
    
    methods
        function obj = inpM(test)
            obj.test = test;
            obj.dGau = bj.test.dGau;
            obj.w = windowLength;
        end
        
        function isAlarm = isAl(obj,tmseries)
        end
        
    end
    
end