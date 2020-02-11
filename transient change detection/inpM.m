classdef inpM < handle
    properties
        alph % alphabet
        dGau % discrete Gaussian sampler
        nBin % number of bins
        test
        wind
    end
    
    methods
        function obj = inpM(test)
            obj.test = test;
            obj.dGau = obj.test.dGau;
            obj.alph = obj.dGau.alph;
            obj.nBin = obj.dGau.nBin;
            obj.wind = obj.test.wind;
        end
        
        function freq = isAl(obj,thre,timS)
            thr1 = thre(1); % first threshold
            thr2 = thre(2); % KL radius
            tSSi = size(timS); % time series' size
            if rem(tSSi(2),obj.wind) ~= 0
                return
            end
            
            timS = reshape(timS,tSSi(1),tSSi(2)/obj.wind,obj.wind);
            mldd = dGau(obj.nBin,thr1); %#ok<CPROPLC> % most likely deviation dist.
            dPdf = mldd.pdVc; % deviation pdf
            dPdf = reshape(dPdf,1,1,obj.nBin);
            repM = repmat(dPdf,tSSi(1),tSSi(2)/obj.wind,1); % replicate matrix dPdf
            sta1 = var(timS,0,3); % statistics 1
            ePdf = obj.myHi(timS); % empirical pdfs
            zMas = ePdf==0; % zero mask
            llrM = log((ePdf+1e-8*zMas)./repM);
            if any(llrM==-Inf)
                return
            end
            
            sta2 = sum(ePdf.*llrM,3); % statistics 2
            isAl = (sta1>=thr1).*(sta2>=thr2);
            isAl = any(isAl,2);
            freq = mean(isAl);
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