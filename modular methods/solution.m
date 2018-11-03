classdef solution < handle
    properties
        problem 
        schemeName % kl/mean/lmp/glr
        parameters
    end
    
    methods
        function obj = solution(problem,schemeName)
            obj.schemeName = schemeName;
            obj.problem = problem;
        end
        
        function detectChange(obj,samples)
            if obj.schemeName == "kl"
                l
            end
            
        end
        
        function h
            k
        end
    end
    
    methods(Static)
    end
    
end