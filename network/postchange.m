classdef postchange
    
    properties
        alphabet = (-4:4)'
        cdf
        pmf
        var
    end
    
    methods
        function obj = postchange
            % pmf with var >= 2
            var = 0;
            while (var < 2 || var > 2.25)
                pmf = obj.uniformRandpmf;
                var = obj.findVar(pmf);
            end
            
            obj.pmf = pmf;
            obj.var = var;
            cdf = cumsum(obj.pmf);
            obj.cdf = [0;cdf(1:end-1)];
        end
        
        function pmf = uniformRandpmf(obj)
            % let pmf/cdf be uniformly random over probability simplex
            seed = rand(8,1);
            cdf = [0;sort(seed)]; %#ok<PROP>
            pmf = [cdf(2:end);1]-cdf; %#ok<PROP>
        end
        
        function outputArg = sample(obj,numSam)
            seed = rand(numSam,1);
            cdfMat = repmat(obj.cdf',numSam,1);
            seedMat = repmat(seed,1,9);
            truMat = seedMat>=cdfMat;
            ind = sum(truMat,2);
            outputArg = obj.alphabet(ind);
        end
        
        function var = findVar(obj,pmf)
            var = pmf'*(obj.alphabet).^2-(pmf'*obj.alphabet)^2;
        end
        
    end
    
end