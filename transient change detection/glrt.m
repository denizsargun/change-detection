classdef glrt < handle
    properties
        w
    end
    
    methods
        function obj = glrt(windowLength)
            obj.w = windowLength;
        end
        
        function isAlarm = test(obj,tmseries)
        end
        
    end
    
end