classdef arl < handle
    
    properties
        csList
        pre
        numRep = 1e3
        timeHor = 1e5
    end
    
    methods
        function obj = arl(csList)
            obj.csList = csList;
            obj.pre = prechange();
        end
        
        function outputArg = repeat(obj)
            csLen = length(obj.csList);
            outputArg = zeros(csLen,1);
            for i = 1:csLen
                n = nipt(obj.csList(i));
                stopSum = 0;
                for j = 1:obj.numRep
                    k = 1;
                    while (n.stopFlag == 0 && k <= obj.timeHor)
                        [i,j,k]
                        sams = obj.pre.sample(3); % samples
                        n.newSample(sams');
                        k = k+1;
                    end
                    
                    if n.stopFlag == 0
                        stop = obj.timeHor;
                    else
                        stop = n.stop;
                    end
                    
                    stopSum = stopSum+stop;
                    n.reset
                end
                
                outputArg(i) = stopSum/obj.numRep;
            end
            
        end
        
    end
    
end