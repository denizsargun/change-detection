classdef delay < handle
    % estimate worst delay
    %   Detailed explanation goes here
    
    properties
        alphabet = [-1; 0; 1]
        arl_max = 2e3 % max sequence length
        b = [-1:1/4:5]'% thresholds for method
        B = 25 % block size
        m % alphabet size
        method
        rep = 1e2 % number of repetitions
        rep_b % number of thresholds
        rep_worst = 40 % number of post-change distributions
        underscore_q = 0.25 % minimum mean for post-change distribution
    end
    
    methods
        function obj = delay()
            obj.m = length(obj.alphabet);
            obj.method = kernel_method;
            obj.rep_b = length(obj.b);
        end
        
        function arl = find_arl(obj)
            % estimate the average run length
            test_sequences = obj.create_pre_change_sequences(obj.arl_max);
            test_results = zeros(obj.rep_b,obj.rep);
            progress = 0;
            for i = 1:obj.rep_b
                obj.method.b = obj.b(i);
                for j = 1:obj.rep
                    test_results(i,j) = obj.method.online(test_sequences(:,i,j));
                    progress = progress+1/(obj.rep_b*obj.rep);
                end
                
            end
            
            arl = mean(test_results,2);
        end
        
        function sequences = create_pre_change_sequences(obj,len)
            seed = randi(obj.m,len,obj.rep_b,obj.rep);
            sequences = obj.alphabet(seed);
        end
        
        function wadd = find_wadd()
            % estimate the worst average detection delay
            
        end
        
    end
end