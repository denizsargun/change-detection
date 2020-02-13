classdef inpM < handle
    properties
        alph % alphabet
        dGau % discrete Gaussian sampler
        dgUt % discrete Gaussian distribution utilities
        nBin % number of bins
        test
        wind
    end
    
    methods
        function obj = inpM(test)
            obj.test = test;
            obj.dGau = obj.test.dGau;
            obj.dgUt = obj.dGau.dgUt;
            obj.alph = obj.dGau.alph;
            obj.nBin = obj.dGau.nBin;
            obj.wind = obj.test.wind;
        end
        
        function freq = isAl(obj,thre,timS)
            if or(thre(1) < 0,thre(2) < 0)
                disp("thre(1) < 0 or thre(2) < 0")
                return
            end
            
            thr1 = thre(1); % first threshold
            thr2 = thre(2); % KL radius
            tSSi = size(timS); % time series' size
            if rem(tSSi(2),obj.wind) ~= 0
                return
            end
            
            timS = reshape(timS,tSSi(1),obj.wind,tSSi(2)/obj.wind);
            sta1 = var(timS,0,2); % statistics 1
            % I-projection of discrete Gaussian on the set of all 
            % distribution with variance >= thr1 is a discrete Gaussian
            % distribution of thr1 <= 10
            mldd = dGau(obj.nBin,thr1); %#ok<CPROPLC> % most likely deviation dist.
            dPdf = mldd.pdVc; % deviation pdf
            repM = repmat(dPdf',tSSi(1),1,tSSi(2)/obj.wind); % replicate matrix dPdf
            ePdf = obj.myHi(timS); % empirical pdfs
            zMas = ePdf == 0; % zero mask
            llrM = log((ePdf+1e-8*zMas)./repM);
            if any(llrM == -Inf)
                return
            end
            
            sta2 = sum(ePdf.*llrM,2); % statistics 2
            isAl = (sta1 >= thr1).*(sta2 >= thr2);
            isAl = any(isAl,3);
            freq = mean(isAl);
        end
        
        function pdfs = myHi(obj,timS) % my histogram
            tSSi = size(timS); % time series' size
            pdfs = zeros(tSSi(1),obj.nBin,tSSi(3));
            for i = 1:obj.nBin
                pdfs(:,i,:) = mean(timS == obj.alph(i),2);
            end
            
        end
        
    end
    
end