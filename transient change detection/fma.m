classdef fma < handle
    properties
        thr
        flt
        w
    end
    
    methods
        function obj = fma(threshold,windowLength)
            obj.thr = threshold;
            obj.w = windowLength;
            obj.flt = tril(triu(ones(200,219)),19);
        end
        
        function isAlarm = test(obj,tmseries)
            ma = obj.flt*tmseries/obj.w;
            isAlarm = sum(ma>=obj.thr)>0;
        end
        
    end
    
end