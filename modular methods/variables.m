classdef variables
    properties
        activeTestIndex
        alpha
        alphabet = [-2 -1 0 1 2]
        alphabetSize
        beta = .5;
        changedDist
        cvxFolder = '\\home2.coeit.osu.edu\s\sargun.1\ECE\Desktop\cvx';
        cvxSetupFile = 'cvx_setup.m';
        iProjError
        excelFile
%       eps=2.22*10^(-16) is the machine precision
%       cvx_precision low: [eps^(6/16);eps^(4/16);eps^(4/16)];
%       cvx_precision medium: [eps^(8/16);eps^(6/16);eps^(4/16)];
%       cvx_precision default: [eps^(8/16);eps^(8/16);eps^(4/16)];
%       cvx_precision high: [eps^(12/16);eps^(12/16);eps^(6/16)];
%       cvx_precision best: [0;eps^(8/16);eps^(4/16)];
        glrCvxPrecision = [eps^(2/16);eps^(1/16);eps^(1/16)];
        glrThrRange = 2.^(2:.25:6)';
        gmaDist
        iProj
        klMeanRange = (0.05:.05:0.5)';
        klRadiusRange = 2.^(-10:1:-2)';
        lmpDir
        lmpThrRange = -2.^(0.5:.15:2)';
        meanMeanRange = (0:.05:0.5)';
        mProj
        mtbf
        numberOfReps = 200;
        performance
        performanceMean
        performanceStd
        pfaIt = [1e2; 1e2; 1e2; 10];
        pmdIt = [1e2; 1e2; 1e2; 10];
        sampleSize = 20;
        stringLength = 1e6;
        testNames = {'kl', 'mean', 'lmp', 'glr'};
        testTime = {'pfa', 'pmd'}; % tic-toc holder
        testTypes
        theta = 0; % not used % learning rate of empirical dist
        unchangedDist = 1/5*ones(5,1);
    end
    
    methods
        function obj = variables()            
            obj.alphabet = sort(obj.alphabet(:));
            obj.alpha = obj.unchangedDist'*obj.alphabet;
            obj.alphabetSize = length(obj.alphabet);
            obj.iProjError = min(abs(obj.alphabet-circshift(obj.alphabet,1)))/1e5;
            % excel file
            date = round(clock);
            singleDigit = find(date < 10);
            dateString = string(date);
            for i = singleDigit(1:end)
                dateString(i) = insertBefore(dateString(i),1,'0');
            end
            
            dateName = strjoin(dateString,'_');
            obj.excelFile = strcat('simulation','_',dateName,'.xlsx');
            % create excel file
            xlswrite(obj.ex.excelFile,{'create excel file'})
            xlswrite(obj.ex.excelFile,obj.ex.alphabet,1,'B1')
            xlswrite(obj.ex.excelFile,obj.ex.beta,1,'C1')
            xlswrite(obj.ex.excelFile,obj.ex.glrThrRange,1,'D1')
            xlswrite(obj.ex.excelFile,obj.ex.klMeanRange,1,'E1')
            xlswrite(obj.ex.excelFile,obj.ex.klRadiusRange,1,'F1')
            xlswrite(obj.ex.excelFile,obj.ex.lmpThrRange,1,'G1')
            xlswrite(obj.ex.excelFile,obj.ex.meanMeanRange,1,'H1')
            xlswrite(obj.ex.excelFile,obj.ex.numberOfReps,1,'I1')
            xlswrite(obj.ex.excelFile,obj.ex.pfaIt,1,'J1')
            xlswrite(obj.ex.excelFile,obj.ex.pmdIt,1,'K1')
            xlswrite(obj.ex.excelFile,obj.ex.sampleSize,1,'L1')
            xlswrite(obj.ex.excelFile,obj.ex.unchangedDist,1,'M1')
            xlswrite(obj.ex.excelFile,obj.ex.cvxPrecision,1,'N1')
            obj.ex.unchangedDist = obj.ex.unchangedDist(:);
            % set lmp direction
            % using i-projection of unchanged dist on set of dists with mean >= beta
            obj.i_proj(obj.ex.unchangedDist,obj.ex.beta)
            obj.ex.lmpDir = obj.ex.iProj-obj.ex.unchangedDist;
            % set i-projection
            klMean = obj.ex.klMeanRange(obj.ex.activeTestIndex{3}(1));
            obj.i_proj(obj.ex.unchangedDist,klMean)
            % cannot initialize mProj
            % because mProj depends on empirical dist
        end
        
    end
    
end