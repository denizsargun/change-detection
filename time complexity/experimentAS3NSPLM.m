classdef experimentAS3NSPLM < handle
    % hold utility object and variables
    % AS refers to alphabet size
    % 2N refers to alphabet size of 3^N, N>0
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
        meanMeanRange
        methodNames
        runner
        sampleSize
        storageFile
        testNames
        unchangedDist
        util % utility toolbox
        writer
    end
    
    methods
        function obj = experimentAS3NSPLM(n,m)
            % save current folder name
            % fid = fopen('directory.txt','w');
            % fprintf(fid,pwd);
            % fclose(fid);
            
            % set up an alphabet with 3^n distinct letters, w/o repeat
            while 1
                dum = randn(3^n,1);
                obj.alphabet = unique(dum);
                if length(obj.alphabet) == 3^n
                    break;
                end
                
            end
            
            obj.glrThrRange = 0;
            obj.it = 1e4*[1; ... % klM time
                1; ... % meanM time
                1];    % glrM time
            obj.klMeanRange = min(obj.alphabet);
            obj.klRadiusRange = 0;
            obj.meanMeanRange = 0;
            obj.methodNames = {'klM', 'meanM', 'glrM'};
            obj.sampleSize = m*3^n;
            obj.testNames = {'timeT'};
            obj.unchangedDist = 3^(-n)*ones(3^n,1);
            obj.util = util(obj);
            obj.util.setup()
            obj.writer = writer(obj);
            % runner is the last obj to be defined
            obj.runner = runner(obj);
            obj.runner.runEx;
        end
        
    end
    
end
