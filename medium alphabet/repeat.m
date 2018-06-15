classdef repeat < handle
    % coordinate number of repetetions for each test
    properties
        klMeanRange = [0.1:0.05:0.4]';
        klRadiusRange = 2.^[-3:-0.5:9]';
        meanMeanRange = [0.1:0.05:0.4]';
        lmpThrRange = [-2:0.5:5];
        glrThrRange = [1:0.5:10]';
        a = [-1 0 1]';
        n = 50;
        q = 1/3*ones(3,1);
        beta = 1/4;
        pfaIt = 1e4;
        pmdIt = 1e4;
        mProjIt = 1e2;
    end
    
    methods
        function obj = repeat()
            for i = klMeanRange
                for j = klRadiusRange
                    klParam = []
                    t = test(obj.a,obj.n,obj.q,obj.beta,klParam,meanParam,lmpParam,glrParam,pfaIt,pmdIt,mProjIt);
                end
                
            end
            
        end
        
        function write(obj)
            % write results to an excel spreadsheet
        end
        
    end
        
end
