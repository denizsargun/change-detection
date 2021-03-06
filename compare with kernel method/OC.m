classdef OC < handle
    % test the probability of misdetection and false alarm
    %   Detailed explanation goes here
    
    properties
        alphabet = [-1; 0; 1]
        b = [-1:1/4:5]'% thresholds for method
        B = 25 % block size
        m % alphabet size
        method
        rep = 5e3 % number of repetitions
        rep_b % number of thresholds
        rep_worst = 40 % number of post-change distributions
        underscore_q = 0.25 % minimum mean for post-change distribution
    end
    
    methods
        function obj = OC()
            obj.m = length(obj.alphabet);
            obj.method = kernel_method;
            obj.rep_b = length(obj.b);
        end
        
        function pfa = find_pfa(obj)
            % estimate the probability of false alarm
            test_sequences = obj.create_pre_change_sequences();
            test_results = zeros(obj.rep_b,obj.rep);
            for i = 1:obj.rep_b
                obj.method.b = obj.b(i);
                for j = 1:obj.rep
                    test_results(i,j) = obj.method.offline(test_sequences(:,i,j));
                end
                
            end
            
            pfa = mean(test_results,2);
        end
        
        function sequences = create_pre_change_sequences(obj)
            seed = randi(obj.m,obj.B,obj.rep_b,obj.rep);
            sequences = obj.alphabet(seed);
        end
        
        function worst_pmd = find_worst_pmd(obj)
            % estimate worst probability of misdetection
            test_results = zeros(obj.rep_b,obj.rep_worst,obj.rep);
            progress = 0;
            for j = 1:obj.rep_worst
                post_change_pmf = obj.get_post_change_pmf();
                test_sequences = obj.create_post_change_sequences(post_change_pmf);
                for i = 1:obj.rep_b
                    obj.method.b = obj.b(i);
                    for k = 1:obj.rep
                        test_results(i,j,k) = obj.method.offline(test_sequences(:,i,k));
                        progress = progress+1/(obj.rep_worst*obj.rep_b*obj.rep) %#ok<NOPRT>
                    end
                    
                end
                
            end
            
            worst_pmd = max(mean(1-test_results,3),[],2);
        end
        
        function sequences = create_post_change_sequences(obj,post_change_pmf)
            sequences = zeros(obj.B,obj.rep_b,obj.rep);
            seed = rand(obj.B,obj.rep_b,obj.rep);
            % alphabet has 3 letters: -1,0,1
            sequences(seed<=post_change_pmf(1)) = obj.alphabet(1);
            % ... = obj.alphabet(2) (=0)
            sequences(seed>1-post_change_pmf(3)) = obj.alphabet(3);
        end
        
        function pmf = get_post_change_pmf(obj)
            mean = 0;
            while mean<obj.underscore_q
                pmf = obj.random_pmf;
                mean = pmf'*obj.alphabet;
            end
            
        end
        
        function pmf = random_pmf(obj)
            seed = [0; sort(rand(obj.m,1))];
            dummy = seed(2:end)-seed(1:end-1);
            pmf = dummy/sum(dummy);
        end
        
    end
    
end

