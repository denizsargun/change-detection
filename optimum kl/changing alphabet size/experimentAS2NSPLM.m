classdef experimentAS2NSPLM < handle
    % hold utility object and variables
    % AS refers to alphabet size
    % 2N refers to alphabet size of 2^N, N>0
    % SPL refers to sample per letter = M
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
        runner
        sampleSize
        storageFile
        testNames
        unchangedDist
        utility % utility toolbox
        writer
    end
    
    methods
        function obj = experimentAS2NSPLM(n,m)
            % save current folder name
            % fid = fopen('directory.txt','w');
            % fprintf(fid,pwd);
            % fclose(fid);
            
            obj.alphabet = -2^(n-1)+1/2:2^(n-1)-1/2;
            obj.beta = 0;
            obj.glrThrRange = 0;
            obj.it = 1e0*[0 0 0 0 1; ... % klM pfa, pd, mtbf, delay, time
                0 0 0 0 1; ... % meanM pfa, pd, mtbf, delay, time
                0 0 0 0 1; ... % lmpM pfa, pd, mtbf, delay, time
                0 0 0 0 1];    % glrM pfa, pd, mtbf, delay, time
            obj.klMeanRange = [-inf, max(obj.alphabet)];
            obj.klRadiusRange = 0;
            obj.lmpThrRange = 0;
            % default MaxFunEvals is 100*numberOfVariables = 500
            obj.maxFunEvals = 100*2^n;
            % default MaxIter is 400
            obj.maxIter = 400;
            obj.meanMeanRange = 0;
            obj.methodNames = {'klM', 'meanM', 'lmpM', 'glrM'};
            obj.sampleSize = m*2^n;
            obj.testNames = {'pfaT','pdT','mtbfT','delayT','timeT'};
            obj.unchangedDist = 2^(-n)*ones(2^n,1);
            obj.utility = utility(obj);
            obj.utility.setup()
            obj.writer = writer(obj);
            % runner is the last obj to be defined
            obj.runner = runner(obj);
            obj.runner.runEx;
        end
        
    end
    
end
