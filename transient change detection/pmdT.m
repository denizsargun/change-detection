classdef pmdT < handle
    properties
        dGau % discrete Gaussian sampler
        dura % duration of the transient change
        fmaM % finite moving average method
        glrM % generalized likelihood ratio method
        inpM % information projection method
        saLe % sample length
    end
    
    methods
        function obj = pmdT()
            obj.dGau = dGau(11,1);
            obj.dura = 75;
            obj.saLe = 2*obj.dura-1;
            obj.fmaM = fmaM(obj);
            obj.glrM = glrM(obj);
            obj.inpM = inpM(obj);
        end
        
        function timS = geTS(obj)
            timS = obj.dGau.sampl(obj.saLe);
        end
        
        function isAl = isAl(obj)
            timS = obj.geTS();
            isAl = zeros(3,1);
            isAl(1) = obj.fmaM.isAl(timS);
            isAl(2) = obj.glrM.isAl(timS);
            isAl(3) = obj.inpM.isAl(timS);
        end
        
    end
    
end