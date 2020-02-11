classdef dGau < handle
    % discrete Gaussian
    properties
        alph % alphabet
        cdVc % cumulative distribution vector
        dgUt % discrete Gaussian distribution utilities
        mean
        nBin % number of bins
        pdVc % probability distribution vector
        thet % theta^2 parameter of discrete Gaussian distribution
        varn % variance of discrete Gaussian distribution
    end
    
    methods
        function obj = dGau(nBin,varn)
            obj.nBin = nBin;
            obj.alph = (-(obj.nBin-1)/2:(obj.nBin-1)/2)';
            obj.dgUt = dgUt(obj);
            obj.varn = varn;
            obj.thet = obj.dgUt.VtoT(obj.varn);
            obj.pdVc = obj.dgUt.VtoN(obj.varn)*exp(-(obj.alph.^2)/(2*obj.thet));
            obj.cdVc = cumsum(obj.pdVc);
            obj.mean = 0;
        end
        
        function samp = samp(obj,m,n)
            seed = rand(m,n);
            lCdV = length(obj.cdVc);
            cdVc = reshape(obj.cdVc,1,1,lCdV); %#ok<PROPLC>
            comp = repmat(seed,1,1,obj.nBin) >= repmat(cdVc,m,n,1); %#ok<PROPLC>
            indx = sum(comp,3)+1;
            samp = obj.alph(indx);
        end
        
    end
    
end