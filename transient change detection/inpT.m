classdef inpT < handle
    properties
        w
    end
    
    methods
        function obj = inpT(windowLength)
            obj.w = windowLength;
        end
        
        function isAlarm = test(obj,tmseries)
        end
        
    end
    
end