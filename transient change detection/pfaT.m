classdef pfaT < handle
    properties
        dGau % discrete Gaussian sampler
        dura % duration of the transient change
        faWi % false alarm window
        iter % iteration
        meth % method
        saLe % sample length
        thrs % threshold
        var0 % pre-change variance
        var1 % minimum post-change variance
    end
    
    methods
        function obj = pfaT()
            obj.dGau = dGau(11,1);
            obj.dura = 20;
            obj.faWi = 200;
            obj.saLe = obj.dura+obj.faWi-1;
            obj.thrs = (-1:0.01:1)';
            obj.var0 = 1;
            obj.var1 = 1.25;
            obj.meth = fmaM(obj);
%             obj.meth = glrM(obj);
%             obj.meth = inpM(obj);
        end
        
        function timS = geTS(obj)
            timS = obj.dGau.sampl(obj.saLe*obj.iter);
        end
        
        function pfaE = repe(obj)
            nThr = length(obj.thrs);
            isAl = zeros(nThr,obj.iter);
            for i = 1:nThr
                thre = obj.thrs(i);
                timS = obj.geTS();
                for j = 1:obj.iter
                    part = timS((j-1)*obj.saLe+1,j*obj.saLe);
                    isAl(i,j) = obj.meth.isAl(thre,part);
                end

            end
            
            pfaE = mean(isAl,2);
        end
        
    end
    
end