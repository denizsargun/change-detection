classdef dGau < handle
    properties
        alph % alphabet
        cdVc % cumulative distribution vector
        mean
        nBin % number of bins
        pdVc % probability distribution vector
        varn % variance of continuous Gaussian random variable ~ discrete
    end
    
    methods
        function obj = dGau(nBin,varn)
            if varn>2
                disp("variance is out of bounds")
                return
            end
            
            obj.nBin = nBin;
            obj.alph = (-(obj.nBin-1)/2:(obj.nBin-1)/2)';
            obj.varn = varn;
            obj.pdVc = exp(-obj.alph.^2/(2*obj.varn));
            obj.pdVc = obj.pdVc/sum(obj.pdVc);
            obj.mean = obj.pdVc'*obj.alph;
            obj.cdVc = cumsum(obj.pdVc);
        end
        
        function samp = samp(obj,k)
            seed = rand(k,1);
            comp = repmat(seed,1,obj.nBin) >= repmat(obj.cdVc',k,1);
            indx = sum(comp,2)+1;
            samp = obj.alph(indx);
        end
        
    end
    
end