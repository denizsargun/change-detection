classdef timeT
    % operation time test
    properties
        ex
        it
        method
        testName
        util
    end
    
    methods
        function obj = timeT(method)
            obj.method = method;
            obj.ex = obj.method.ex;
            obj.it = obj.method.it(1);
            obj.testName = 'timeT';
            obj.util = obj.method.util;
        end
        
        function time = test(obj)
            totalTime = 0;
            for i = 1:obj.it
                dist = obj.util.uniformly_random_dist_NEW();
                empDist = obj.util.realize(dist);
                % no need to assign the output isChange
                [~, time] = obj.method.is_change(empDist);
                totalTime = totalTime+time;
            end
            
            time = totalTime/obj.it;
        end
        
    end
    
end