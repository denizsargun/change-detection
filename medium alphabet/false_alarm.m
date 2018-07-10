classdef false_alarm < handle
    % execute false alarm tests for each method    
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
        function obj = false_alarm(test)
            obj.test = test;
            obj.klMean = test.klParam(1);
            obj.klRadius = test.klParam(2);
            obj.meanParam = test.meanParam;
            obj.lmpDir = test.lmpParam(1:end-1);
            obj.lmpThr = test.lmpParam(end);
            obj.glrParam = test.glrParam;
        end
        
        function run_pfa(obj,method)
            % possible methods: 'kl_test', 'mean_test', 'lmp_test',
            % 'glr_test', 'all'
            if strcmp(method,'kl_test') || strcmp(method,'all')
                obj.kl_pfa();
            end
            
            if strcmp(method,'mean_test') || strcmp(method,'all')
                obj.mean_pfa();
            end
            
            if strcmp(method,'lmp_test') || strcmp(method,'all')
                obj.lmp_pfa();
            end
            
            if strcmp(method,'glr_test') || strcmp(method,'all')
                obj.glr_pfa();
            end

        end
        
%         function kl_pfa(obj)
%             % probability of false alarm for the KL divergence test
%             numberOfFalseAlarms = 0;
%             total = 0;
%             for i = 1:obj.test.pfaIt
%                 [dist,numberOfTrials] = obj.test.util.realize_mean(obj.test.q,obj.klMean);
%                 numberOfFalseAlarms = numberOfFalseAlarms+obj.test.klTest.kl_change(dist);
%                 total = total+numberOfTrials;
%             end
%             
%             obj.test.klPerf(1) = numberOfFalseAlarms/total;
%         end

        function kl_pfa(obj)
            % probability of false alarm for the KL divergence test
            numberOfFalseAlarms = 0;
            for i = 1:obj.test.pfaIt
                dist = obj.test.util.realize(obj.test.q);
                numberOfFalseAlarms = numberOfFalseAlarms+obj.test.klTest.is_change(dist);
            end
            
            obj.test.klPerf(1) = numberOfFalseAlarms/obj.test.pfaIt;
        end
        
%         function mean_pfa(obj)
%             total = 0;
%             for i = 1:obj.test.pfaIt
%                 [~,numberOfTrials] = obj.test.util.realize_mean(obj.test.q,obj.meanParam);
%                 % no need to test at this point since the returned dist has
%                 % mean(dist) >= meanParam
%                 total = total+numberOfTrials;
%             end
%             
%             obj.test.meanPerf(1) = obj.test.pfaIt/total;
%         end

        function mean_pfa(obj)
            numberOfFalseAlarms = 0;
            for i = 1:obj.test.pfaIt
                dist = obj.test.util.realize(obj.test.q);
                numberOfFalseAlarms = numberOfFalseAlarms+obj.test.meanTest.is_change(dist);
            end
            
            obj.test.meanPerf(1) = numberOfFalseAlarms/obj.test.pfaIt;
        end
        
        function lmp_pfa(obj)
            numberOfFalseAlarms = 0;
            for i = 1:obj.test.pfaIt
                dist = obj.test.util.realize(obj.test.q);
                numberOfFalseAlarms = numberOfFalseAlarms+obj.test.lmpTest.is_change(dist);
            end
            
            obj.test.lmpPerf(1) = numberOfFalseAlarms/obj.test.pfaIt;
        end
        
        function glr_pfa(obj)
            numberOfFalseAlarms = 0;
            for i = 1:obj.test.pfaIt
                dist = obj.test.util.realize(obj.test.q);
                numberOfFalseAlarms = numberOfFalseAlarms+obj.test.glrTest.is_change(dist);
                disp('threshold parameter')
                obj.test.glrParam
                disp('false alarm test number')
                i
            end
            
            obj.test.glrPerf(1) = numberOfFalseAlarms/obj.test.pfaIt;
        end
        
    end
    
end