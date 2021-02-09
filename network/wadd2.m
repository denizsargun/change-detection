classdef wadd2 < handle
    % same as wadd but with worst case over change points
    properties
        csList
        chPs = kron(10.^[0;1;2;3;4],[1;2;5]); % change points to be maximized over 1,2,5,...,50000
        posts = {}
        numDis = 1e3; % num of post change dist to choose worst from
        numRep = 1e3
        timeHor = 1e3
    end
    
    methods
        function obj = wadd2(csList)
            obj.csList = csList;
            obj.setposts()
        end
        
        function setposts(obj)
            for k = 1:obj.numDis
                obj.posts{k} = postchange;
            end
            
        end
        
        function outputArg = repeat(obj)
            cPLen = length(obj.chPs);
            csLen = length(obj.csList);
            outputArg = zeros(csLen,1);
            for i = 1:cPLen
                for j = 1:csLen
                    n = nipt(obj.csList(j));
                    for k = 1:obj.numDis
                        stopSum = 0;
                        for l = 1:obj.numRep
                            m = 1;
                            while (n.stopFlag == 0 && m <= obj.timeHor)
                                [j,k,l,m]
                                sams = obj.posts{k}.sample(3); % samples
                                n.newSample(sams');
                                m = m+1;
                            end

                            if n.stopFlag == 0
                                stop = obj.timeHor;
                            else
                                stop = n.stop;
                            end

                            stopSum = stopSum+stop;
                            n.reset
                        end

                        outputArg(j) = max(outputArg(j),stopSum/obj.numRep);
                    end

                end
                
            end
            
        end
        
    end
    
end