classdef pdT
    % probability of detection test
    properties
        changedDist
        ex
        it
        method
        testName
        utility
    end
    
    methods
        function obj = pdT(method)
            obj.method = method;
            obj.ex = obj.method.ex;
            obj.it = obj.method.it(2);
            obj.testName = 'pdT';
            obj.utility = obj.method.utility;
        end
        
        function pd = test(obj)
            % probability of detection
            numberOfDetections = 0;
            for i = 1:obj.it
                obj.changedDist = ...
                    obj.utility.random_dist_mean_NEW(obj.ex.beta);
                dist = obj.utility.realize(obj.changedDist);
                numberOfDetections = numberOfDetections ...
                    +obj.method.is_change(dist);
            end
            
            pd = numberOfDetections/obj.it;
        end
        
    end
    
end