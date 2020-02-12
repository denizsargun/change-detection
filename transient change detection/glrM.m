classdef glrM < handle
    properties
        alph % alphabet
        dGau % discrete Gaussian sampler
        dgUt % discrete Gaussian distribution utilities
        nBin % number of bins
        test
        the0 % pre-change theta^2
        the1 % minimum post-change theta^2
        var0 % pre-change variance
        var1 % minimum post-change variance
        wind % window length
    end
    
    methods
        function obj = glrM(test)
            obj.test = test;
            obj.dGau = obj.test.dGau;
            obj.alph = obj.dGau.alph;
            obj.dgUt = obj.dGau.dgUt;
            obj.nBin = obj.dGau.nBin;
            obj.var0 = obj.test.var0;
            obj.var1 = obj.test.var1;
            obj.the0 = obj.dgUt.VtoT(obj.var0);
            obj.the1 = obj.dgUt.VtoT(obj.var1);
            obj.wind = obj.test.wind;
        end
        
        function freq = isAl(obj,thre,timS)
            tSSi = size(timS); % time series' size
            if rem(tSSi(2),obj.wind) ~= 0
                return
            end
            
            timS = reshape(timS,tSSi(1),obj.wind,tSSi(2)/obj.wind);
            estm = obj.estm(timS);
            noCo = obj.dgUt.TtoN(estm);
%             dum1 = repmat(obj.alph',tSSi(1),1,tSSi(2)/obj.wind);
            dum2 = repmat(estm,1,obj.wind,1);
            dum3 = repmat(noCo,1,obj.wind,1);
%             post = dum3.*exp(-(dum1.^2)./(2*dum2));
%             prev = reshape(obj.dGau.pdVc,1,1,obj.nBin);
%             prev = repmat(prev,tSSi(1),tSSi(2)/obj.wind);
            post = dum3.*exp(-(timS.^2)./(2*dum2));
            prev = obj.dgUt.VtoN(obj.var0)*exp(-(timS.^2)/(2*obj.the0));
            llrM = post./prev;
%             pdfs = obj.myHi(timS);
%             stat = sum(pdfs.*llrM,3)*obj.wind;
            stat = mean(llrM,2);
            isAl = stat>thre;
            isAl = any(isAl,3);
            freq = mean(isAl);
        end
        
        function estm = estm(obj,timS)
            % estimate the post-change parameter theta^2 via max likelihood
            % the estimate estm satisfies the following condition:
            % difference between the second moments of empirical and
            % m-projection distributions is minimized
            mom2 = mean(timS.^2,2); % second moment empirical
            mask = mom2<obj.var1;
            mas2 = mom2>9.96; % mask 2
            dum1 = (mask+mas2)+(1-(mask+mas2)).*mom2;
            estm = (1-(mask+mas2)).*obj.dgUt.VtoT(dum1) ...
                +mask*obj.the1+mas2*1e3;
        end
        
        function pdfs = myHi(obj,timS) % my histogram
            tSSi = size(timS); % time series' size
            pdfs = zeros(tSSi(1),tSSi(2),obj.nBin);
            for i = 1:obj.nBin
                pdfs(:,:,i) = mean(timS==obj.alph(i),3);
            end
            
        end
        
    end
    
end