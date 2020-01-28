classdef fmaM < handle
    properties
        aCon % additive constant in log likelihood ratio
        mCon % multiplicative constant in log likelihood ratio
        test
        wndw % window length
    end
    
    methods
        function obj = fmaM(test)
            obj.test = test;
            dGau = obj.test.dGau;
            noCo = dGau.noCo;
            var0 = obj.test.var0;
            var1 = obj.test.var1;
            obj.aCon = log(noCo(var1)/noCo(var0));
            obj.mCon = (var1-var0)/(2*var0*var1);
            obj.wndw = wndw;
        end
        
        function isAl = isAl(obj,thre,timS)
            stat = obj.mCon*timS.^2+obj.aCon;
            movS = movsum(stat,[obj.wndw-1,0]);
            movS = movS(obj.wndw:end);
            isAl = any(movS>=thre);
        end
        
    end
    
end