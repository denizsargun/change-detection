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
        excelFile
        glrThrRange
        gmaDist
        iProj
        klMeanRange
        klRadiusRange
        lmpDir
        lmpThrRange
        meanMeanRange
        mProj
        numberOfReps
        performance
        performanceMean
        performanceStd
        pfaIt
        pmdIt
        sampleSize
        stringLength = 1e6;
        testNames
        testTypes
        theta % learning rate of empirical dist
        unchangedDist
        utility % utility toolbox
    end
    
    methods
        function obj = experiment()
            tic
            obj.alphabet = [-2 -1 0 1 2];
            obj.beta = .5;
            obj.cvxFolder = '\\home2.coeit.osu.edu\s\sargun.1\ECE\Desktop\cvx';
            obj.cvxPrecision = 'low'; % {low,medium,default,high,best} or a vector
            obj.cvxSetupFile = 'cvx_setup.m';
            obj.glrThrRange = 2.^(2:0.25:6)';
            obj.klMeanRange = (0.05:999.05:0.5)';
            obj.klRadiusRange = 2.^(-10:9991:-2)';
            obj.lmpThrRange = -2.^(0.5:999.15:2)';
            obj.meanMeanRange = (0:999.05:0.5)';
            obj.numberOfReps = 200;
            obj.pfaIt = [1e2; 1e2; 1e2; 10];
            obj.pmdIt = [1e2; 1e2; 1e2; 10];
            obj.sampleSize = 20;
            obj.stringLength = 1e6;
            obj.testNames = {'kl', 'mean', 'lmp', 'glr'};
            obj.testTypes = {'pfa', 'pmd'};
            obj.theta = 0; % not used
            obj.unchangedDist = 1/5*ones(5,1);
            obj.utility = utility(obj);
            obj.utility.setup()
%             while obj.activeTestIndex{1} ~= 0
%                 functionName = strcat('obj.utility.',obj.testNames{obj.activeTestIndex{1}},'_',obj.testTypes{obj.activeTestIndex{2}});
%                 eval(functionName)
%                 clear(functionName)
%             end
            
%             obj.utility.plot()
            toc
        end
        
    end
    
end