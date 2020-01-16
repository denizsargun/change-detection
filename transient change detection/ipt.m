classdef ipt < handle
    properties
        w
    end
    
    methods
        function obj = ipt(windowLength)
            obj.w = windowLength;
        end
        
        function isAlarm = test(obj,tmseries)
        end
        
    end
    
end