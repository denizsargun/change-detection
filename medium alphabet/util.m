classdef util < handle
    % utility functions for testing
    % ex: find mean, compute Kullback Leibler divergence, I-project some
    % dist
    properties
        test % main test object
        a % alphabet
        m % alphabet size
        n % sample size
        q % unchanged distribution
        beta % minimum mean for changed distribution
        eps % maximum allowable I-projection error in mean
    end
    
    methods
        function obj = util(test)
            obj.a = test.a;
            obj.m = test.m;
            obj.n = test.n;
            obj.q = test.q;
            obj.beta = test.beta;
            obj.eps = test.eps;
        end
        
        function d = mean(obj,p)
            d = obj.a'*p;
        end

        function proj = i_proj(obj,dist,mean)
            % I-project dist to the convex set {mean(dist)>=mean}
            proj = dist;
            if obj.mean(proj)>= mean
                return
            end
            
            % since the set is convex and alphabet is finite
            % the projection is the minimum tilt tilted distribution
            % tilt dist iteratively until error is small
            err = (mean-obj.mean(proj))*inf;
            while abs(err)>obj.eps
                proj = proj.*exp(sign(err)*obj.eps*obj.a);
                proj = proj/sum(proj);
                err = mean-obj.mean(proj);
            end
            
        end
           
        function p = emp_prob_calc(obj,dist,emp_dist)
            % calculate the probability of observing emp_dist from dist in
            % n trials
            d2 = zeros(obj.n,1);
            d3 = obj.n*tril(ones(obj.n),-1)*emp_dist;
            for i = 1:obj.m
                d2(round(d3(i))+1:round(d3(i+1))) = 1:round(obj.n*emp_dist(i)); % debugging rounding error by round()
            end
    
            % alternative for loop:
            % d2 = 1
            % for i = 1:obj.m
            %     d2 = d2*fact(obj.n*emp_dist(i));
            % end
            p = prod((1:obj.n)'./d2); % multinomial coefficient
            p = p*prod(dist.^(obj.n*emp_dist));
        end
        
        function dist = uniformly_random_dist(obj)
            % select a distribution at uniformly random
            dist = rand(obj.m,1);
            dist = dist/sum(p);
        end
        
        function dist = random_dist_mean(obj)
            % select a distribution with mean >= beta at uniformly random
            mean = -inf;
            while mean < obj.beta
                dist = obj.uniformly_random_dist();
                mean = obj.mean(dist);
            end
            
        end
        
        function realEmpDist = realize(obj,dist)
            randomSeed = rand(obj.n,1);
            seedInMatrix = ones(obj.m,1)*randomSeed'; % concatenated matrix
            strLowerTri = tril(ones(obj.m),-1);
            checkDist = strLowerTri*dist*ones(1,obj.n);
            % realIndex = sum(seedInMatrix >= checkDist);
            % realSeq = obj.a(realIndex); % sequence of realizations
            emp_ccdf = sum(seedInMatrix >= checkDist,2)/obj.n; % like ccdf
            realEmpDist = emp_ccdf-[emp_ccdf(2:end); 0]; % realized empirical distribution
        end
        
    end
    
    methods (Static)
        function d = kl_d(p,q) % base e
            nonzeroIndex = (p~=0);
            p = p(nonzeroIndex);
            q = q(nonzeroIndex);
            d = p.*log(p./q);
        end
        
        
    end

end
