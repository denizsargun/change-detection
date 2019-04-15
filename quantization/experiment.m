% experiment to measure the effect of quantization
% quantize N(0,1) using 2^{n+1} bins from -2^n to 2^n
classdef experiment < handle
    % hold utility object and variables
    properties
        alpha
        alphabet
        alphabetSize
        beta
        glrThrRange
        it
        klMeanRange
        klRadiusRange
        lmpThrRange
        maxFunEvals
        maxIter
        meanMeanRange
        methodNames
        preChange
        quantParam % quantization parameter
        runner
        sampleSize
        storageFile
        testNames
        utility % utility toolbox
        writer
    end
    
    methods
        function obj = experiment(quantParam)
            % save current folder name
            % fid = fopen('directory.txt','w');
            % fprintf(fid,pwd);
            % fclose(fid);
            
            obj.beta = 1/4;
            obj.it = 1e4*[1 1 0 0 0; ... % klM pfa, pd, mtbf, delay, time
                1 1 0 0 0];    % meanM pfa, pd, mtbf, delay, time
            obj.methodNames = {'klM', 'meanM'};
            obj.quantParam = quantParam;
            obj.sampleSize = 25;
            obj.testNames = {'pfaT','pdT'};
            obj.utility = utility(obj);
            obj.utility.setup()
            obj.writer = writer(obj);
            % runner is the last obj to be defined
            obj.runner = runner(obj);
            obj.runner.runEx;
        end
        
    end
    
end
