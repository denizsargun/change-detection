classdef betaBinom < handle
    properties
        n
        a
        b
    end
    
    methods
        function obj = betaBinom(numTri,alpha,beta)
            if numTri<0 or isinteger(numTri)
                disp("numTri is negative or not an integer")
                return
            end
            
            if alpha<=0
                disp("alpha is not positive")
                return
            end
            
            if beta<=0
                disp("beta is not positive")
                return
            end
            
            obj.n = numTri;
            obj.a = alpha;
            obj.b = beta;
        end
        
        function samples = getSample(obj,k)
            beta = betarnd(obj.a,obj.b,[k,1]);
            samples = binornd(obj.n,beta);
        end
        
    end
    
end