classdef performance < handle
    properties
        type % probability/run time
        scenario % before/after change
        name % pfa/pmd///wcdd/mtbf
        problem
        parameters
    end
    
    methods
        function obj = performance(type,name)
            obj.type = type;
            obj.name = name;
            
        end
        
    end
    
    methods(Static)
    end
    
end