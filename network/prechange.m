classdef prechange
    
    properties
        alphabet = (-4:4)'
        cdf
        pmf
    end
    
    methods
        function obj = prechange
            % pmf with var = 1
            pmf = exp(-obj.alphabet.^2/2.00014415);
            obj.pmf = pmf/sum(pmf);
            cdf = cumsum(obj.pmf);
            obj.cdf = [0;cdf(1:end-1)];
        end
        
        function outputArg = sample(obj,numSam)
            seed = rand(numSam,1);
            cdfMat = repmat(obj.cdf',numSam,1);
            seedMat = repmat(seed,1,9);
            truMat = seedMat>=cdfMat;
            ind = sum(truMat,2);
            outputArg = obj.alphabet(ind);
        end
        
    end
    
end