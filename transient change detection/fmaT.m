classdef fmaT < handle
    properties
        thre % threshold
        wndw % window length
    end
    
    methods
        function obj = fmaT(wndw)
            obj.wndw = wndw;
        end
        
        function isAlarm = test(obj,tmseries)
            ma = obj.flt*tmseries/obj.w;
            isAlarm = sum(ma>=obj.thr)>0;
        end
        
    end
    
end