classdef kernel_method < handle
    % M-Statistic for Kernel Change-Point Detection by Li et al.
    %   Detailed explanation goes here
    
    properties
        alphabet = [-1; 0; 1]
        b % threshold
        B = 25 % block size for offline problem
        B0 = 50 % block size for online problem
        m % alphabet size
        N = 10 % number of blocks
    end
    
    methods
        function obj = kernel_method()
            obj.m = length(obj.alphabet);
        end
        
        function is_change = offline(obj,Y)
            % find if Y i.i.d. f_0 or i.i.d. f_1
            %  compute M-statistics given change point is 1 or inf
            matrix_X = obj.create_reference_blocks(obj.B,obj.N);
            mmd_u_sq = zeros(obj.N,1);
            for i = 1:obj.N
                mmd_u_sq(i) = obj.find_mmd_u_sq(matrix_X(:,i),Y);
            end
            
            M = sqrt(obj.B*(obj.B-1))*mean(mmd_u_sq);
            if M>obj.b
                is_change = 1;
            else
                is_change = 0;
            end
            
        end
        
        function blocks = create_reference_blocks(obj,B,N)
            seed = randi(obj.m,B,N);
            blocks = obj.alphabet(seed);
        end
        
        function stat = find_mmd_u_sq(obj,X,Y)
            % estimate of the maximum mean discrepancy using U-statistics
            %   compute empirical distributions
            B = length(X); %#ok<PROPLC>
            pmf_X = obj.find_emp_pmf(X);
            pmf_Y = obj.find_emp_pmf(Y);
            stat = B/(B-1)*norm(pmf_X-pmf_Y)^2-2/(B*(B-1))*nnz(X-Y); %#ok<PROPLC>
        end
        
        function emp_pmf = find_emp_pmf(obj,X)
            % find empirical distribution of X
            emp_pmf = zeros(obj.m,1);
            B = length(X); %#ok<PROPLC>
            for i = 1:obj.m
                emp_pmf(i) = sum(X==obj.alphabet(i))/B; %#ok<PROPLC>
            end
            
        end
        
    end
    
end

