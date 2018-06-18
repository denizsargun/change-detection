classdef misdetection < handle
    % execute misdetection tests for each method    
    properties
        test % test object
        klMean
        klRadius
        meanParam
        lmpDir
        lmpThr
        glrParam
    end
    
    methods
        function obj = misdetection(test)
            obj.test = test;
            obj.klMean = test.klParam(1);
            obj.klRadius = test.klParam(2);
            obj.meanParam = test.meanParam;
            obj.lmpDir = test.lmpParam(1:end-1);
            obj.lmpThr = test.lmpParam(end);
            obj.glrParam = test.glrParam;
        end
        
        function run_pmd(obj,method)
            % possible methods: 'kl_test', 'mean_test', 'lmp_test',
            % 'glr_test', 'all'
            if strcmp(method,'kl_test') || strcmp(method,'all')
                obj.kl_pmd();
            end
            
            if strcmp(method,'mean_test') || strcmp(method,'all')
                obj.mean_pmd();
            end
            
            if strcmp(method,'lmp_test') || strcmp(method,'all')
                obj.lmp_pmd();
            end
            
            if strcmp(method,'glr_test') || strcmp(method,'all')
                obj.glr_pmd();
            end

        end
        
        function kl_pmd(obj)
            % probability of misdetection for the KL divergence test
            numberOfMisdetections = 0;
            for i = 1:obj.test.pmdIt
                dist = obj.test.util.random_dist_mean(obj.test.beta);
                empDist = obj.test.util.realize(dist);
                numberOfMisdetections = numberOfMisdetections+(1-obj.test.klTest.is_change(empDist));
            end
            
            obj.test.klPerf(2) = numberOfMisdetections/obj.test.pmdIt;
        end

        function mean_pmd(obj)
            numberOfMisdetections = 0;
            for i = 1:obj.test.pmdIt
                dist = obj.test.util.random_dist_mean(obj.test.beta);
                empDist = obj.test.util.realize(dist);
                numberOfMisdetections = numberOfMisdetections+(1-obj.test.meanTest.is_change(empDist));
            end
            
            obj.test.meanPerf(2) = numberOfMisdetections/obj.test.pmdIt;
        end
        
        function lmp_pmd(obj)
            numberOfMisdetections = 0;
            for i = 1:obj.test.pmdIt
                dist = obj.test.util.random_dist_mean(obj.test.beta);
                empDist = obj.test.util.realize(dist);
                numberOfMisdetections = numberOfMisdetections+(1-obj.test.lmpTest.is_change(empDist));
            end
            
            obj.test.lmpPerf(2) = numberOfMisdetections/obj.test.pmdIt;
        end
        
        function glr_pmd(obj)
            numberOfMisdetections = 0;
            for i = 1:obj.test.pmdIt
                dist = obj.test.util.random_dist_mean(obj.test.beta);
                empDist = obj.test.util.realize(dist);
                numberOfMisdetections = numberOfMisdetections+(1-obj.test.glrTest.is_change(empDist));
            end
            
            obj.test.glrPerf(2) = numberOfMisdetections/obj.test.pmdIt;
        end
        
    end
    
end