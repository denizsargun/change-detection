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
            proj = dist;
            if obj.mean(proj)>= mean
                return
            end
            
            % since the set is convex and alphabet is finite
            % the projection is the minimum tilt tilted distribution
            % tilt dist iteratively until error is small
            err = inf;
            while abs(err)>obj.eps
                proj = proj.*exp(sign(err)*obj.eps*obj.test.a);
                proj = proj/sum(proj);
                err = mean-obj.mean(proj);
            end
            
            obj.test.iProj = proj;
        end
           
        function p = emp_prob_calc(obj,dist,emp_dist)
            % calculate the probability of observing emp_dist from dist in
            % n trials
            d2 = zeros(obj.test.n,1);
            d3 = obj.test.n*tril(ones(obj.test.m),-1)*emp_dist;
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
            while mean < err
                realEmpDist = obj.realize(dist);
                err = mean-obj.mean(realEmpDist);
                numberOfTrials = numberOfTrials+1;
            end
            
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
