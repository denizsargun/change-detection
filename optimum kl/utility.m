classdef utility < handle
    
    % utility toolbox
    
    % dictionary
    % dist      = distribution
    % emp       = empirical
    % ex        = experiment
    % glr       = generalized likelihood ratio
    % i proj    = information projection
    % kl        = Kullback Leibler
    % mtbf      = mean time between failures
    % lmp       = locally most powerful
    % m proj    = moment projection
    % pfa       = probability of false alarm
    % pd        = probability of detection
    % wcdd      = worst case detection delay
    
    properties
        ex
    end
    
    methods
        function obj = utility(experiment)
            obj.ex = experiment;
        end
        
        % initialize
        function setup(obj)
            % alphabet
            % alphabet is a sorted column vector
            obj.ex.alphabet = sort(obj.ex.alphabet(:));
            obj.ex.alpha = obj.mean(obj.ex.unchangedDist);
            obj.ex.alphabetSize = length(obj.ex.alphabet);
            
            % excel file
            date = clock;
            date(6) = round(date(6));
            dateName = mat2str(date);
            dateName = dateName(2:end-1);
            dateName = strrep(dateName,' ','_');
            % try .xls or .xlsx
            obj.ex.storageFile = strcat('experiment','_',dateName,'.xls');
            % add POI librariy to java path to use xlwrite
            javaaddpath('poi_library/poi-3.8-20120326.jar');
            javaaddpath('poi_library/poi-ooxml-3.8-20120326.jar');
            javaaddpath('poi_library/poi-ooxml-schemas-3.8-20120326.jar');
            javaaddpath('poi_library/xmlbeans-2.3.0.jar');
            javaaddpath('poi_library/dom4j-1.6.1.jar');
            % create excel file
            % use xlwrite insted of xlswrite
            xlwrite(obj.ex.storageFile,{'create excel file'});
            xlwrite(obj.ex.storageFile,'alphabet',1,'B1');
            xlwrite(obj.ex.storageFile,obj.ex.alphabet,1,'B2');
            xlwrite(obj.ex.storageFile,'beta',1,'C1');
            xlwrite(obj.ex.storageFile,obj.ex.beta,1,'C2');
            xlwrite(obj.ex.storageFile,'glrThrRange',1,'D1');
            xlwrite(obj.ex.storageFile,obj.ex.glrThrRange,1,'D2');
            xlwrite(obj.ex.storageFile,'klMeanRange',1,'E1');
            xlwrite(obj.ex.storageFile,obj.ex.klMeanRange,1,'E2');
            xlwrite(obj.ex.storageFile,'klRadiusRange',1,'F1');
            xlwrite(obj.ex.storageFile,obj.ex.klRadiusRange,1,'F2');
            xlwrite(obj.ex.storageFile,'lmpThrRange',1,'G1');
            xlwrite(obj.ex.storageFile,obj.ex.lmpThrRange,1,'G2');
            xlwrite(obj.ex.storageFile,'meanMeanRange',1,'H1');
            xlwrite(obj.ex.storageFile,obj.ex.meanMeanRange,1,'H2');
            xlwrite(obj.ex.storageFile,'it',1,'I1');
            xlwrite(obj.ex.storageFile,obj.ex.it(:),1,'I2');
            xlwrite(obj.ex.storageFile,'sampleSize',1,'J1');
            xlwrite(obj.ex.storageFile,obj.ex.sampleSize,1,'J2');
            xlwrite(obj.ex.storageFile,'unchangedDist',1,'K1');
            xlwrite(obj.ex.storageFile,obj.ex.unchangedDist,1,'K2');
            xlwrite(obj.ex.storageFile,'maxIter',1,'L1');
            xlwrite(obj.ex.storageFile,obj.ex.maxIter,1,'L2');
            xlwrite(obj.ex.storageFile,'maxFunEvals',1,'M1');
            xlwrite(obj.ex.storageFile,obj.ex.maxFunEvals,1,'M2');
            
            % unchanged dist
            % column vector of dist
            obj.ex.unchangedDist = obj.ex.unchangedDist(:);
        end
        
        % utilities
        function d = mean(obj,dist)
            d = obj.ex.alphabet'*dist;
        end
        
        function iProjSet = i_proj(obj,dist,meanRange,eps)
            iProjSet = cell(length(meanRange),1);
            for i = 1:length(obj.klMeanRange)
                mean = obj.klMeanRange(i);
                % I-project dist to the convex set {mean(dist)>=mean}
                iProjSet{i} = dist;
                if obj.mean(iProjSet{i}) >= mean
                    return
                end
                
                % since the set is convex and alphabet is finite
                % the projection is the minimum tilt tilted distribution
                % tilt dist iteratively until error is small
                err = inf;
                while abs(err)>eps
                    iProjSet{i} = iProjSet{i}.*exp(sign(err) ...
                        *eps*obj.ex.alphabet);
                    iProjSet{i} = iProjSet{i}/sum(iProjSet{i});
                    err = mean-obj.mean(iProjSet{i});
                end
                
            end
        end
        
        function mProj = m_proj(obj,dist,mean)
            % find M-projection of dist over set
            % of distributions with mean(dist)>= mean
            % 1. computing the mProj is a convex problem
            % 2. it is optimal to have support(mProj) as a subset
            % of support(dist) for the problem without the mean constraint,
            % ie. if dist was a finite sequence of nonnegative numbers,
            % unnormalized
            % 3. if mean(dist)>= mean, dist is optimal
            
            % use fmincon
            if obj.mean(dist) >= mean
                mProj = dist;
            else
                % if mean(dist) < mean, then mean(projection) = mean
                fun = @(x) dist'*log(1./x);
                % initializing
                wmin = (obj.ex.alphabet(end)-mean) ...
                    /(obj.ex.alphabet(end)-obj.ex.alphabet(1));
                x0 = wmin;
                x0(obj.ex.alphabetSize) = 1-wmin;
                x0 = x0';
                % dummy inequality constraints
                A = zeros(1,obj.ex.alphabetSize);
                b = 0;
                % equality constraints for normalization and mean
                Aeq = [ones(1,obj.ex.alphabetSize); obj.ex.alphabet'];
                beq = [1; mean];
                % lower and upper bounds for proj
                lb = zeros(obj.ex.alphabetSize,1);
                ub = ones(obj.ex.alphabetSize,1);
                nonlcon = [];
                % options = optimoptions('fmincon','MaxFunEvals',obj.ex.maxFunEvals);
                options = optimoptions('fmincon','MaxIter',obj.ex.maxIter);
                mProj = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
            end
            
        end
        
        function p = emp_prob_calc(obj,dist,emp_dist)
            % calculate the probability of observing emp_dist from dist in
            % sampleSize trials
            d2 = zeros(obj.ex.sampleSize,1);
            d3 = tril(ones(obj.ex.alphabetSize),-1) ...
                *obj.ex.sampleSize*emp_dist;
            d3(obj.ex.alphabetSize+1) = obj.ex.sampleSize;
            for i = 1:obj.ex.alphabetSize
                % debugging rounding error by round()
                d2(round(d3(i))+1:round(d3(i+1))) = ...
                    1:round(obj.ex.sampleSize*emp_dist(i));
            end
            
            % multinomial coefficient
            p = prod((1:obj.ex.sampleSize)'./d2);
            p = p*prod(dist.^(obj.ex.sampleSize*emp_dist));
        end
        
        function dist = uniformly_random_dist(obj)
            % select a distribution at uniformly random realizable with
            % sampleSize samples
            uniDist = 1/obj.ex.alphabetSize*ones(obj.ex.alphabetSize,1);
            dist = obj.realize(uniDist);
        end
        
        function [dist,numberOfTrials] = random_dist_mean(obj,mean)
            % select a distribution with mean >= beta at uniformly random
            % realizable with sampleSize samples
            numberOfTrials = 0;
            err = inf;
            while mean < err
                dist = obj.uniformly_random_dist();
                err = mean-obj.mean(dist);
                numberOfTrials = numberOfTrials+1;
            end
            
        end
        
        function realEmpDist = realize(obj,dist)
            % realize dist sampleSize times and output the empirical dist
            randomSeed = rand(obj.ex.sampleSize,1);
            % concatenated matrix
            seedInMatrix = ones(obj.ex.alphabetSize,1)*randomSeed';
            strLowerTri = tril(ones(obj.ex.alphabetSize),-1);
            checkDist = strLowerTri*dist*ones(1,obj.ex.sampleSize);
            % realIndex = sum(seedInMatrix >= checkDist);
            % sequence of realizations
            % realSeq = obj.ex.alphabet(realIndex);
            % like ccdf
            emp_ccdf = sum(seedInMatrix >= checkDist,2)/obj.ex.sampleSize;
            % realized empirical distribution
            realEmpDist = emp_ccdf-[emp_ccdf(2:end); 0];
        end
        
        function [realEmpDist,numberOfTrials] = realize_mean(obj,dist,mean)
            % realize dist sampleSize times and output the empirical dist
            % if mean(dist) >= mean
            numberOfTrials = 0;
            err = inf;
            while 0 < err
                realEmpDist = obj.realize(dist);
                err = mean-obj.mean(realEmpDist);
                numberOfTrials = numberOfTrials+1;
            end
            
        end
        
        function write_excel(obj)
            sheet = ...
                strcat(obj.ex.methodNames{},'_');
            timeSheet = ...
                strcat(obj.ex.methodNames{},'_','_time');
            if strcmp(obj.ex.methodNames{},'klM')
                % klMean = m, klRadius = r
                % m(1)r(1), m(1)r(2), ..., m(2)r(1), m(2)r(2), ...
                add = (-1) ...
                    *length(obj.ex.klRadiusRange) ...
                    +;
            else
                add = ;
            end
            
            % convert number into A, B, ..., AA, AB, ... format used in
            % excel: 1>A, 10>J, 25>Y, 26>Z, 27>AA, 28>AB, ...
            v = dec2base(add-1,26)+(dec2base(add-1,26)>57)*10 ...
                +(dec2base(add-1,26)<=57)*17-1;
            v(end) = v(end)+1;
            cellLetters = char(v);
            cellNumber = ;
            cell = char(cellLetters+string(cellNumber));
            xlwrite(obj.ex.storageFile,result,sheet,cell);
            xlwrite(obj.ex.storageFile,time,timeSheet,cell);
        end
                
    end
    
    methods (Static)
        function d = kl_distance(p,q)
            % base e logarithm
            nonzeroIndex = (p~=0);
            p = p(nonzeroIndex);
            q = q(nonzeroIndex);
            d = p'*log(p./q);
        end
        
    end
    
end
