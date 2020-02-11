classdef fmaM < handle
    properties
        aCon % additive constant in log likelihood ratio
        dGau % discrete Gaussian sampler
        dgUt % discrete Gaussian distribution utilities
        mCon % multiplicative constant in log likelihood ratio
        test
        the0 % pre-change theta^2
        the1 % minimum post-change theta^2
        var0 % pre-change variance
        var1 % minimum post-change variance
        wind % window size
    end
    
    methods
        function obj = fmaM(test)
            obj.test = test;
            obj.dGau = obj.test.dGau;
            obj.dgUt = obj.dGau.dgUt;
            obj.var0 = obj.test.var0;
            obj.var1 = obj.test.var1;
            obj.aCon = log(obj.dgUt.VtoN(obj.var1)/obj.dgUt.VtoN(obj.var0));
            obj.the0 = obj.dgUt.VtoT(obj.var0);
            obj.the1 = obj.dgUt.VtoT(obj.var1);
            obj.mCon = (obj.the1-obj.the0)/(2*obj.the0*obj.the1);
            obj.wind = obj.test.wind;
        end
        
        function freq = isAl(obj,thre,timS)
            tSSi = size(timS); % time series' size
            if rem(tSSi(2),obj.wind) ~= 0
                disp("time series is not multiple of window size")
                return
            end
            
            timS = reshape(timS,tSSi(1),obj.wind,tSSi(2)/obj.wind);
            stat = obj.mCon*timS.^2+obj.aCon; % statistics
            aSta = mean(stat,2); % average statistics
            isAl = any(aSta>=thre,3);
            freq = mean(isAl); % frequency
        end
        
    end
    
end