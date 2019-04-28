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
            obj.glrThrRange = 2.^(0:1:10)';
            obj.it = 1e3*[0 0; ... % klM mtbf, delay
                0 0; ... % meanM mtbf, delay
                1 1];    % glrM mtbf, delay
            obj.klMeanRange = (0:0.5:max(obj.alphabet)-0.5)';
            obj.klRadiusRange = 2.^(-7:1:-3)';
            obj.meanMeanRange = (min(obj.alphabet):.2:max(obj.alphabet)-0.5)';
            obj.methodNames = {'klM', 'meanM', 'glrM'};
            obj.sampleSize = 25;
            obj.testNames = {'mtbfT','delayT'};
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
