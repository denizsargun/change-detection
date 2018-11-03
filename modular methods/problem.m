classdef problem
    properties
        alpha
        alphabet
        alphabetSize
        beta
        solutions
        unchangedDist
    end
    
    methods
        function obj = problem(alphabet,unchangedDist,beta)
            obj.alphabet = sort(alphabet(:));
            obj.alphabetSize = length(obj.alphabet);
            obj.unchangedDist = unchangedDist(:);
            obj.alpha = obj.unchangedDist'*obj.alphabet;
            obj.beta = beta;
        end
        
    end
    
end