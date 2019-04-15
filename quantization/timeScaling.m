classdef timeScaling < handle
    % test the time complexity scaling with alphabet size
    % this code is RUDIMENTARY
    properties
        alphabetSizes % chose odd numbers
        ex
        writer
    end
    
    methods
        function obj = timeScaling(alphabetSizes)
            obj.alphabetSizes = alphabetSizes;
            obj.ex = experiment();
            % keep the writer fixed
            obj.writer = obj.ex.writer;
        end
        
        function createExp(obj,alphabetSize)
            ex = experiment();
            maxLetter = (alphabetSize-1)/2;
            ex.alphabet = -maxLetter:maxLetter;
            ex.alphabetSize = alphabetSize;
            % for a fixed SNR beta scales with alphabetSize
            % for alphabetSize = 5, beta = .5
            ex.beta = sqrt(alphabetSize^2-1/96);
            obj.it = 1e4*[0 0 0 0 1; ... % klM pfa, pd, mtbf, delay, time
                0 0 0 0 1; ... % meanM pfa, pd, mtbf, delay, time
                0 0 0 0 1; ... % lmpM pfa, pd, mtbf, delay, time
                0 0 0 0 1];
            % keep storage file fixed
            ex.storageFile = obj.ex.storageFile;
            % we let kl mean scale with beta
            % operation times do not depend on other tests' parameters
            ex.klMeanRange = ex.beta/2;
            % we let sample size grow with alphabet size
            ex.sampleSize = 5*alphabetSize;
            ex.preChange = 1/alphabetSize*ones(alphabetSize,1);
            ex.utility = utility(ex);
            % keep the writer fixed
            ex.writer = obj.writer(ex);
            obj.ex = ex;
        end
        
        function run(obj)
            for i = 1:length(obj.alphabetSizes)
                obj.createExp(obj.alphabetSizes(i))
                
            end
            
        end
        
    end
    
end