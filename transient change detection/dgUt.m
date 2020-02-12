classdef dgUt < handle
    % discrete Gaussian distribution utilities
    properties
        alph % alphabet
        nBin % number of bins
        noCo % normalization constant
        pdMt % probability distribution matrix
        thet % theta^2
        varn % variance
    end
    
    methods
        function obj = dgUt(dGau)
            obj.alph = dGau.alph;
            obj.nBin = dGau.nBin;
            obj.thet = (0.001:0.001:1000)';
            dum1     = repmat(obj.alph',length(obj.thet),1);
            dum2     = repmat(obj.thet,1,obj.nBin);
            obj.pdMt = exp(-(dum1.^2)./(2*dum2));
            obj.noCo = 1./sum(obj.pdMt,2);
            obj.pdMt = obj.pdMt.*repmat(obj.noCo,1,obj.nBin);
            obj.varn = sum((dum1.^2).*obj.pdMt,2);
        end
        
        function noCo = TtoN(obj,thet)
            thSi = size(thet);
            thet = thet(:);
            if any(thet <= 0)
                disp("theta <= 0")
                return
            end
            
            noCo = interp1q(obj.thet,obj.noCo,thet);
            noCo = reshape(noCo,thSi);
        end
        
        function noCo = VtoN(obj,varn)
            vaSi = size(varn);
            varn = varn(:);
            if any(varn <= 0)
                disp("variance <= 0")
                return
            end
            
            if any(varn >= 10)
                disp("variance >= 10")
                return
            end
            
            noCo = interp1q(obj.varn,obj.noCo,varn);
            noCo = reshape(noCo,vaSi);
        end
        
        function varn = TtoV(obj,thet)
            thSi = size(thet);
            thet = thet(:);
            if any(thet <= 0)
                disp("theta <= 0")
                return
            end
            
            varn = interp1q(obj.thet,obj.varn,thet);
            varn = reshape(varn,thSi);
        end
        
        function thet = VtoT(obj,varn)
            vaSi = size(varn);
            varn = varn(:);
            if any(varn <= 0)
                disp("variance <= 0")
                return
            end
            
            if any(varn >= 10)
                disp("variance >= 10")
                return
            end
            
            thet= interp1q(obj.varn,obj.thet,varn);
            thet = reshape(thet,vaSi);
        end
        
    end
    
end