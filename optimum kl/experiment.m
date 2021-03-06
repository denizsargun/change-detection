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
        runner
        sampleSize
        storageFile
        testNames
        unchangedDist
        utility % utility toolbox
        writer
    end
    
    methods
        function obj = experiment()
            % save current folder name
            % fid = fopen('directory.txt','w');
            % fprintf(fid,pwd);
            % fclose(fid);
            
            obj.alphabet = [-1 0 1];
            obj.beta = 1/4;
            obj.glrThrRange = 2.^(0:.25:10)';
            obj.it = 1e4*[1 1 0 0 0; ... % klM pfa, pd, mtbf, delay, time
                1 1 0 0 0; ... % meanM pfa, pd, mtbf, delay, time
                0 0 0 0 0; ... % lmpM pfa, pd, mtbf, delay, time
                1 1 0 0 0];    % glrM pfa, pd, mtbf, delay, time
            obj.klMeanRange = (0:.05:max(obj.alphabet))';
            obj.klRadiusRange = 2.^(-8:1:-3)';
            obj.lmpThrRange = -2.^(0:.2:2.4)';
            % default MaxFunEvals is 100*numberOfVariables = 500
            obj.maxFunEvals = 500;
            % default MaxIter is 400
            obj.maxIter = 400;
            obj.meanMeanRange = (min(obj.alphabet):.05:max(obj.alphabet))';
            obj.methodNames = {'klM', 'meanM', 'lmpM', 'glrM'};
            obj.sampleSize = 25;
            obj.testNames = {'pfaT','pdT','mtbfT','delayT','timeT'};
            obj.unchangedDist = 1/3*ones(3,1);
            obj.utility = utility(obj);
            obj.utility.setup()
            obj.writer = writer(obj);
            % runner is the last obj to be defined
            obj.runner = runner(obj);
            obj.runner.runEx;
        end
        
    end
    
end
