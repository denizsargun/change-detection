classdef false_alarm < handle
    % execute false alarm tests for each method    
    properties
        test
        klTest
        klDivPfa
        it
    end
    
    methods
        function obj = pfa(test,method)
            % initialize
            obj.test = test;
            obj.klTest = test.klTest;
            obj.klDivPfa = test.klPerf(1);
            obj.it = test.pfaIt;
            % possible methods: 'kl_div_test', 'mean_test', 'lmp_test',
            % 'glr_test', 'all'
            if strcmp(method,'kl_div_test') || strcmp(method,'all')
                obj.pfa = [obj.pfa; obj.kl_div_pfa()];
            end
            
            if strcmp(method,'mean_test') || strcmp(method,'all')
                obj.pfa = [obj.pfa; obj.mean_pfa()];
            end
            
            if strcmp(method,'lmp_test') || strcmp(method,'all')
                obj.pfa = [obj.pfa; obj.lmp_pfa()];
            end
            
            if strcmp(method,'glr_test') || strcmp(method,'all')
                obj.pfa = [obj.pfa; obj.glr_pfa()];
            end

        end
        
        function kl_div_pfa(obj)
            % probability of false alarm for the KL divergence test
            
            for i = 1:obj.it
                obj.klDivPfa = 0;
                obj.test.dist = util.random_dist_mean();
                if obj.klTest.kl_change()
                    p = obj.test.util.emp_prob_calc();
                    obj.klDivPfa = obj.klDivPfa+p/obj.it;
                end
               
            end
            
        end
        
    end
    
end

