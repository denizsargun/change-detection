classdef glrT < handle
    properties
        w
    end
    
    methods
        function obj = glrT(windowLength)
            obj.w = windowLength;
        end
        
        function isAlarm = test(obj,tmseries)
        end
        
    end
    
end