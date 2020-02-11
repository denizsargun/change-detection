classdef glrM < handle
    properties
        alph % alphabet
        dGau % discrete Gaussian sampler
        dgUt % discrete Gaussian distribution utilities
        nBin % number of bins
        test
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
            obj.var1 = obj.test.var1;
            obj.wind = obj.test.wind;
        end
        
        function freq = isAl(obj,thre,timS)
            tSSz = size(timS); % time series' size
            if rem(tSSz(2),obj.wind) ~= 0
                return
            end
            
            timS = reshape(timS,tSSz(1),obj.wind,tSSz(2)/obj.wind);
            estm = obj.estm(timS);
            alph = reshape(obj.alph,1,1,obj.nBin); %#ok<PROPLC>
            post = repmat(alph,tSSz(1),tSSz(2)/obj.wind); %#ok<PROPLC>
            post = exp(-(post.^2)./(2*estm));
            sums = sum(post,3);
            post = post./repmat(sums,1,1,obj.nBin);
            prev = reshape(obj.dGau.pdVc,1,1,obj.nBin);
            prev = repmat(prev,tSSz(1),tSSz(2)/obj.wind);
            llrM = post./prev;
            pdfs = obj.myHi(timS);
            stat = sum(pdfs.*llrM,3)*obj.wind;
            isAl = stat>thre;
            isAl = any(isAl,2);
            freq = mean(isAl);
        end
        
        function estm = estm(obj,timS)
            % estimate the post-change parameter via maximum likelihood
            % the estimate estm satisfies the following condition:
            % difference between the second moments of empirical and
            % m-projection distributions is minimized
            mom2 = mean(timS.^2,3); % second moment empirical
            mask = mom2<obj.var1;
            estm = (1-mask).*mom2+mask*obj.var1;
        end
        
        function pdfs = myHi(obj,timS) % my histogram
            tSSz = size(timS); % time series' size
            pdfs = zeros(tSSz(1),tSSz(2),obj.nBin);
            for i = 1:obj.nBin
                pdfs(:,:,i) = mean(timS==obj.alph(i),3);
            end
            
        end
        
    end
    
end