classdef pfaT < handle
    properties
        alpS % alphabet size
        dGau % discrete Gaussian sampler
        dura % duration of the transient change
        faWi % false alarm window
        fmaT % finite moving average test
        glrT % generalized likelihood ratio test
        inpT % information projection test
        saLe % sample length
    end
    
    methods
        function obj = pfaT()
            obj.alpS = 11;
            obj.dGau = dGau(11,1);
            obj.dura = 20;
            obj.faWi = 200;
            obj.fmaT = fma(1,obj.dura);
            obj.glrT = glrt(obj.dura);
            obj.inpT = ipt(obj.dura);
            obj.saLe = obj.dura+obj.faWi-1;
        end
        
        function timS = geTS(obj)
            timS = obj.dGau.sampl(obj.saLe);
        end
        
        function isAl = isAl(obj)
            timS = obj.geTS();
            isAl = zeros(3,1);
            isAl(1) = obj.fmaT.test(timS);
            isAl(2) = obj.inpT.test(timS);
            isAl(3) = obj.glrT.test(timS);
        end
        
    end
    
end