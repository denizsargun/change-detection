classdef fmaM < handle
    properties
        aCon % additive constant in log likelihood ratio
        mCon % multiplicative constant in log likelihood ratio
        test
        wind % window size
    end
    
    methods
        function obj = fmaM(test)
            obj.test = test;
            dGau = obj.test.dGau;
            noCo = dGau.noCo;
            var0 = obj.test.var0;
            var1 = obj.test.var1;
            obj.aCon = log(noCo.getC(var1)/noCo.getC(var0));
            obj.mCon = (var1-var0)/(2*var0*var1);
            obj.wind = obj.test.wind;
        end
        
        function freq = isAl(obj,thre,timS)
            tSSz = size(timS); % time series' size
            if rem(tSSz(2),obj.wind) ~= 0
                return
            end
            
            timS = reshape(timS,tSSz(1),tSSz(2)/obj.wind,obj.wind);
            stat = obj.mCon*timS.^2+obj.aCon; % statistics
            aSta = mean(stat,3); % average statistics
            isAl = any(aSta>=thre,2);
            freq = mean(isAl); % frequency
        end
        
    end
    
end