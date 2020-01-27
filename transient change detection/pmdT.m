classdef pmdT < handle
    properties
        alpS % alphabet size
        dGau % discrete Gaussian sampler
        dura % duration of the transient change
        fmaT % finite moving average test
        glrT % generalized likelihood ratio test
        inpT % information projection test
        saLe % sample length
    end
    
    methods
        function obj = pmdT()
            obj.alpS = 11;
            obj.dura = 20;
            obj.saLe = 2*obj.dura-1;
            obj.fmaT = fmaT(obj.dura);
            obj.glrT = glrT(obj.dura);
            obj.inpT = inpT(obj.dura);
        end
        
        function timS = geTS(obj)
            timS = obj.dGau.sampl(obj.saLe);
        end
        
        function isAl = isAl(obj)
            timS = obj.geTS();
            isAl = zeros(3,1);
            isAl(1) = obj.fmaT.test(timS);
            isAl(2) = obj.glrT.test(timS);
            isAl(3) = obj.inpT.test(timS);
        end
        
    end
    
end