classdef pdT
    % probability of detection test
    properties
        changedDist
        ex
        it
        method
        utility
    end
    
    methods
        function obj = pdT(method)
            obj.method = method;
            obj.ex = obj.method.ex;
            obj.utility = obj.ex.utility;
        end
        
        function test(obj)
            numberOfDetections = 0;
            % probability of detection
            obj.changedDist = obj.utility.random_dist_mean(obj.ex.beta);
            for i = 1:obj.it
                empDist = obj.utility.realize(obj.changedDist);
                numberOfDetections = numberOfDetections ...
                    +obj.method.is_change(empDist);
                obj.changedDist = ...
                    obj.utility.random_dist_mean(obj.ex.beta);
            end
            
        end
        
    end
end

