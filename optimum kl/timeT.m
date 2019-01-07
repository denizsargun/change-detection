classdef timeT
    % operation time test
    properties
        ex
        it
        method
        testName
        utility
    end
    
    methods
        function obj = timeT(method)
            obj.method = method;
            obj.ex = obj.method.ex;
            obj.it = obj.method.it(5);
            obj.testName = 'timeT';
            obj.utility = obj.method.utility;
        end
        
        function time = test(obj)
            if obj.it == 0
                time = -1;
                return
            end
            
            totalTime = 0;
            for i = 1:obj.it
                dist = obj.utility.uniformly_random_dist();
                empDist = obj.utility.realize(dist);
                time = tic;
                % no need to assign the output isChange
                obj.method.is_change(empDist);
                totalTime = totalTime+toc(time);
            end
            
           time = totalTime/obj.it;
        end
        
    end
    
end