classdef wadd < handle
    
    properties
        csList
        posts = {}
        numDis = 1e3; % num of post change dist to choose worst from
        numRep = 1e3
        timeHor = 1e3
    end
    
    methods
        function obj = wadd(csList)
            obj.csList = csList;
            obj.setposts()
        end
        
        function setposts(obj)
            for j = 1:obj.numDis
                obj.posts{j} = postchange;
            end
            
        end
        
        function outputArg = repeat(obj)
            csLen = length(obj.csList);
            outputArg = zeros(csLen,1);
            for i = 1:csLen
                n = nipt(obj.csList(i));
                for j = 1:obj.numDis
                    stopSum = 0;
                    for k = 1:obj.numRep
                        l = 1;
                        while (n.stopFlag == 0 && l <= obj.timeHor)
                            [i,j,k,l]
                            sams = obj.posts{j}.sample(3); % samples
                            n.newSample(sams');
                            l = l+1;
                        end

                        if n.stopFlag == 0
                            stop = obj.timeHor;
                        else
                            stop = n.stop;
                        end

                        stopSum = stopSum+stop;
                        n.reset
                    end
                
                    outputArg(i) = max(outputArg(i),stopSum/obj.numRep);
                end
                
            end
            
        end
        
    end
    
end