classdef util < handle
    % utility functions for testing
    % ex: find mean, compute Kullback Leibler divergence, I-project dist
    properties
        test % test object
        beta % minimum mean for changed distribution
        eps % maximum allowable I-projection error in mean
    end
    
    methods
        function obj = util(test)
            obj.test = test;
            obj.beta = test.beta;
            obj.eps = test.eps;
        end
        
        function d = mean(obj,p)
            d = obj.test.a'*p;
        end

        function i_proj(obj,dist,mean)
            % I-project dist to the convex set {mean(dist)>=mean}
            obj.test.iProj = dist;
            if obj.mean(obj.test.iProj)>= mean
                return
            end
            
            % since the set is convex and alphabet is finite
            % the projection is the minimum tilt tilted distribution
            % tilt dist iteratively until error is small
            err = inf;
            while abs(err)>obj.eps
                obj.test.iProj = obj.test.iProj.*exp(sign(err)*obj.eps*obj.test.a);
                obj.test.iProj = obj.test.iProj/sum(obj.test.iProj);
                err = mean-obj.mean(obj.test.iProj);
            end
            
        end
        
        function m_proj(obj,dist,mean)
            % iterative optimization to find M-projection of dist over set
            % of distributions with mean(dist)>= mean
            % 1. computing the mProj is a convex problem
            % 2. it is optimal to have support(mProj) as a subset
            % of support(dist) for the problem without the mean constraint,
            % ie. if dist was a finite sequence of nonnegative numbers,
            % unnormalized
            % 3. if mean(dist)>= mean, dist is optimal
%             method 1, incorrect
%             obj.test.mProj = dist;
%             if obj.mean(obj.test.mProj) >= mean
%                 return
%             end
%             
%             for i = 1:obj.test.mProjIt
%                 obj.gradient_step(dist,obj.test.mProjLearningRate/i);
%                 obj.proj(); % obj.proj() is NOT a suitable projection,
%                 % projection should be on the constrained set defined by
%                 % the mean
%             end

%             method 2, slow
%             obj.test.mProj = dist;
%             if obj.mean(obj.test.mProj) >= mean
%                 return
%             end
% 
%             minD = inf;
%             for i = 1:obj.test.mProjIt
%                 [dummy, ~] = obj.realize_mean(dist,mean);
%                 d = obj.kl_d(dist,dummy);
%                 if d <= minD
%                     minD = d;
%                     obj.test.mProj = dummy;
%                 end
%                 
%             end

            % method 3, use cvx
            % to use cvx matlab package run cvx_setup.m from
            % http://cvxr.com/cvx/download/ (CVX Research Inc.)
            cvx_begin quiet
            variable proj(obj.test.m)
            proj >= 0
            sum(proj) == 1
            obj.test.a'*proj >= mean
            minimize(-dist'*log(proj))
            cvx_end
            obj.test.mProj = proj;
        end
        
%         function gradient_step(obj,dist,rate)
%             % rate is learning rate
%             obj.test.mProj = obj.test.mProj+rate*dist./obj.test.mProj;
%         end
%         
%         function proj(obj)
%             % project onto the probability simplex
%             s = sum(obj.test.mProj);
%             obj.test.mProj = obj.test.mProj-(s-1)/obj.test.m*ones(obj.test.m,1);
%             if sum(obj.test.mProj>= zeros(obj.test.m)) == obj.test.m
%                 return
%             else
%                 while sum(obj.test.mProj>= zeros(obj.test.m)) ~= obj.test.m
%                     % min(mProj) is negative
%                     [minm, minIndex] = min(obj.test.mProj);
%                     obj.test.mProj = obj.test.mProj+minm/(obj.test.m-1)*ones(obj.test.m,1);
%                     obj.test.mProj(minIndex) = 0;
%                 end
%                 
%             end
%             
%         end
           
        function p = emp_prob_calc(obj,dist,emp_dist)
            % calculate the probability of observing emp_dist from dist in
            % n trials
            d2 = zeros(obj.test.n,1);
            d3 = tril(ones(obj.test.m),-1)*obj.test.n*emp_dist;
            d3(obj.test.m+1) = obj.test.n;
            for i = 1:obj.test.m
                d2(round(d3(i))+1:round(d3(i+1))) = 1:round(obj.test.n*emp_dist(i)); % debugging rounding error by round()
            end
    
            % alternative for loop:
            % d2 = 1
            % for i = 1:obj.test.m
            %     d2 = d2*fact(obj.test.n*emp_dist(i));
            % end
            p = prod((1:obj.test.n)'./d2); % multinomial coefficient
            p = p*prod(dist.^(obj.test.n*emp_dist));
        end
        
%         function dist = uniformly_random_dist(obj)
%             % select a distribution at uniformly random
%             dist = rand(obj.test.m,1);
%             dist = dist/sum(dist);
%         end
%         
%         function [dist,numberOfTrials] = random_dist_mean(obj,mean)
%             % select a distribution with mean >= beta at uniformly random
%             numberOfTrials = 0;
%             err = inf;
%             while mean < err
%                 dist = obj.uniformly_random_dist();
%                 err = mean-obj.mean(dist);
%                 numberOfTrials = numberOfTrials+1;
%             end
%             
%         end
        
        function dist = uniformly_random_dist(obj)
            % select a distribution at uniformly random realizable with n
            % samples
            uniDist = 1/obj.test.m*ones(obj.test.m,1);
            dist = obj.realize(uniDist);
        end
        
        function [dist,numberOfTrials] = random_dist_mean(obj,mean)
            % select a distribution with mean >= beta at uniformly random
            % realizable with n samples
            numberOfTrials = 0;
            err = inf;
            while mean < err
                dist = obj.uniformly_random_dist();
                err = mean-obj.mean(dist);
                numberOfTrials = numberOfTrials+1;
            end
            
        end

        function realEmpDist = realize(obj,dist)
            % realize dist n times and output the empirical dist
            randomSeed = rand(obj.test.n,1);
            seedInMatrix = ones(obj.test.m,1)*randomSeed'; % concatenated matrix
            strLowerTri = tril(ones(obj.test.m),-1);
            checkDist = strLowerTri*dist*ones(1,obj.test.n);
            % realIndex = sum(seedInMatrix >= checkDist);
            % realSeq = obj.test.a(realIndex); % sequence of realizations
            emp_ccdf = sum(seedInMatrix >= checkDist,2)/obj.test.n; % like ccdf
            realEmpDist = emp_ccdf-[emp_ccdf(2:end); 0]; % realized empirical distribution
        end
        
        function [realEmpDist,numberOfTrials] = realize_mean(obj,dist,mean)
            % realize dist n times and output the empirical dist if mean(dist) >=
            % mean
            numberOfTrials = 0;
            err = inf;
            while 0 < err
                realEmpDist = obj.realize(dist);
                err = mean-obj.mean(realEmpDist);
                numberOfTrials = numberOfTrials+1;
            end
            
        end
        
        function geometric_moving_average_empirical_dist(obj,sample)
            sampleDist = alphabet==sample;
            obj.gmaDist = obj.theta*obj.gmaDist+sampleDist;
            obj.gmaDist = obj.gmaDist/sum(obj.gmaDist);
        end
        
    end
    
    methods (Static)
        function d = kl_d(p,q) % base e
            nonzeroIndex = (p~=0);
            p = p(nonzeroIndex);
            q = q(nonzeroIndex);
            d = p'*log(p./q);
        end
        
    end

end
