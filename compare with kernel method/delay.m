classdef delay < handle
    % estimate worst delay
    %   Detailed explanation goes here
    
    properties
        alphabet = [-1; 0; 1]
        arl_max = 2e3 % max pre-change sequence length
        b = [1:1/4:7]'% thresholds for method
        B = 25 % block size
        m % alphabet size
        method
        rep = 1e3 % number of repetitions
        rep_b % number of thresholds
        rep_worst = 100 % number of post-change distributions
        underscore_q = 0.25 % minimum mean for post-change distribution
        wadd_max = 1e3 % max post-change sequence length
    end
    
    methods
        function obj = delay()
            obj.m = length(obj.alphabet);
            obj.method = kernel_method;
            obj.rep_b = length(obj.b);
        end
        
        function arl = find_arl(obj)
            % estimate the average run length
            test_sequences = obj.create_pre_change_sequences();
            test_results = zeros(obj.rep_b,obj.rep);
            progress = 0;
            for i = 1:obj.rep_b
                obj.method.b = obj.b(i);
                for j = 1:obj.rep
                    test_results(i,j) = obj.method.online(test_sequences(:,i,j));
                    progress = progress+1/(obj.rep_b*obj.rep)
                end
                
            end
            
            arl = mean(test_results,2);
        end
        
        function sequences = create_pre_change_sequences(obj)
            seed = randi(obj.m,obj.arl_max,obj.rep_b,obj.rep);
            sequences = obj.alphabet(seed);
        end
        
        function wadd = find_wadd(obj)
            % estimate the worst average detection delay
            test_results = zeros(obj.rep_b,obj.rep);
            progress = 0;
            for j = 1:obj.rep_worst
                post_change_pmf = obj.get_post_change_pmf();
                test_sequences = obj.create_post_change_sequences(post_change_pmf);
                for i = 1:obj.rep_b
                    obj.method.b = obj.b(i);
                    for k = 1:obj.rep
                        test_results(i,j,k) = obj.method.online(test_sequences(:,i,k));
                        progress = progress+1/(obj.rep_worst*obj.rep_b*obj.rep) %#ok<NOPRT>
                    end
                    
                end
                
            end
            
            wadd = max(mean(test_results,3),[],2);
        end
        
        function pmf = random_pmf(obj)
            seed = [0; sort(rand(obj.m,1))];
            dummy = seed(2:end)-seed(1:end-1);
            pmf = dummy/sum(dummy);
        end
        
        function pmf = get_post_change_pmf(obj)
            mean = 0;
            while mean<obj.underscore_q
                pmf = obj.random_pmf;
                mean = pmf'*obj.alphabet;
            end
            
        end
        
        function sequences = create_post_change_sequences(obj,post_change_pmf)
            sequences = zeros(obj.wadd_max,obj.rep_b,obj.rep);
            seed = rand(obj.wadd_max,obj.rep_b,obj.rep);
            % alphabet has 3 letters: -1,0,1
            sequences(seed<=post_change_pmf(1)) = obj.alphabet(1);
            % ... = obj.alphabet(2) (=0)
            sequences(seed>1-post_change_pmf(3)) = obj.alphabet(3);
        end
        
    end
end