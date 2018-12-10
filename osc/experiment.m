classdef experiment < handle
    % hold utility object and variables
    % run algorithm
    % plot results
    properties
        activeTestIndex
        alpha
        alphabet
        alphabetSize
        beta
        changedDist
        cvxFolder
        cvxPrecision
        cvxSetupFile
        eps
        storageFile
        glrThrRange
        gmaDist
        iProj
        klMeanRange
        klRadiusRange
        maxFunEvals
        maxIter
        lmpDir
        lmpThrRange
        meanMeanRange
        mProj
        mtbf
        numberOfReps
        performance
        performanceMean
        performanceStd
        pfaIt
        pmdIt
        sampleSize
        stringLength
        testNames
        testTime % tic-toc holder
        testTypes
        theta % learning rate of empirical dist
        unchangedDist
        utility % utility toolbox
    end
    
    methods
        function obj = experiment()
            fid = fopen('directory.txt','w');
            fprintf(fid,pwd);
            fclose(fid);
            obj.alphabet = [-2 -1 0 1 2];
            obj.beta = .5;
            obj.cvxFolder = ...
                '\\home2.coeit.osu.edu\s\sargun.1\ECE\Desktop\cvx';
%             eps=2.22*10^(-16) is the machine precision
%             cvx_precision low: [eps^(6/16);eps^(4/16);eps^(4/16)];
%             cvx_precision medium: [eps^(8/16);eps^(6/16);eps^(4/16)];
%             cvx_precision default: [eps^(8/16);eps^(8/16);eps^(4/16)];
%             cvx_precision high: [eps^(12/16);eps^(12/16);eps^(6/16)];
%             cvx_precision best: [0;eps^(8/16);eps^(4/16)];
            obj.cvxPrecision = [eps^(1/4);eps^(1/8);eps^(1/16)];
            obj.cvxSetupFile = 'cvx_setup.m';
            obj.glrThrRange = 2.^(0:.25:10)';
            obj.klMeanRange = (0:.05:0.5)';
            obj.klRadiusRange = 2.^(-9:1:-1)';
            % default MaxFunEvals is 100*numberOfVariables = 500
            obj.maxFunEvals = 400;
            % default MaxIter is 400
            obj.maxIter = 10;
            obj.lmpThrRange = -2.^(0:.2:2.4)';
            obj.meanMeanRange = (-1:.05:1)';
            obj.numberOfReps = 200;
            obj.pfaIt = [1e2; 1e2; 1e2; 1e2];
            obj.pmdIt = [1e2; 1e2; 1e2; 1e2];
            obj.sampleSize = 20;
            obj.stringLength = 1e6;
            obj.testNames = {'kl', 'mean', 'lmp', 'glr'};
            obj.testTypes = {'pfa', 'pmd'};
            obj.theta = 0; % not used
            obj.unchangedDist = 1/5*ones(5,1);
            obj.utility = utility(obj);
            obj.utility.setup()
            while obj.activeTestIndex{1} ~= 0
%                 functionName = strcat('obj.utility.', ...
%                     obj.testNames{obj.activeTestIndex{1}},'_mtbf');
%                 eval(functionName)
                functionName = strcat('obj.utility.', ...
                    obj.testNames{obj.activeTestIndex{1}},'_', ...
                    obj.testTypes{obj.activeTestIndex{2}});
                eval(functionName)
                clear(functionName)
            end
            
%             obj.utility.plot()
        end
        
    end
    
end
