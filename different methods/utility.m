classdef utility < handle
    % utility toolbox
    properties
        ex
    end
    
    methods
        function obj = utility(experiment)
            obj.ex = experiment;
        end
        
        %% setup
        function setup(obj)
            %% initialize test indeces
            % performance is a cell array
            % {test name index, test type index, parameter index/indices, repetition}
            obj.ex.activeTestIndex = {1, 1, [1; 1], 1};
            %% alphabet
            % alphabet is a sorted column vector
            obj.ex.alphabet = sort(obj.ex.alphabet(:));
            obj.ex.alpha = obj.mean(obj.ex.unchangedDist);
            obj.ex.alphabetSize = length(obj.ex.alphabet);
            %% set changed dist with mean >= beta
            obj.ex.changedDist = obj.random_dist_mean(obj.ex.beta);
            %% cvx
            % setup cvx
            % http://cvxr.com/cvx/download/ (CVX Research Inc.)
            % do the cvx setup only ONCE at the beginning of opening a
            % Matlab command window
            run(fullfile(obj.ex.cvxFolder,obj.ex.cvxSetupFile))
            %% eps
            obj.ex.eps = min(abs(obj.ex.alphabet-circshift(obj.ex.alphabet,1)))/1e5;
            %% excel file
            date = clock;
            date(6) = round(date(6));
            dateName = mat2str(date);
            dateName = dateName(2:end-1);
            dateName = strrep(dateName,' ','_');
            obj.ex.excelFile = strcat('experiment','_',dateName,'.xlsx');
            % create excel file
            xlswrite(obj.ex.excelFile,{'create excel file'})
            %% set empirical observation
            obj.ex.gmaDist = zeros(obj.ex.alphabetSize,1);
            %% set performance
            obj.ex.performance = -inf;
            obj.ex.performanceMean = containers.Map;
            % std is normalized by N-1
            obj.ex.performanceStd = containers.Map;
            %% unchanged dist
            % column vector of dist
            obj.ex.unchangedDist = obj.ex.unchangedDist(:);
            %% set lmp direction
            % using i-projection of unchanged dist on set of dists with mean >= beta
            obj.i_proj(obj.ex.unchangedDist,obj.ex.beta)
            obj.ex.lmpDir = obj.ex.iProj-obj.ex.unchangedDist;
            %% set i-projection
            klMean = obj.ex.klMeanRange(obj.ex.activeTestIndex{3}(1));
            obj.i_proj(obj.ex.unchangedDist,klMean)
            %% cannot initialize mProj
            % because mProj depends on empirical dist
        end
        
        %% utilities
        function d = mean(obj,dist)
            d = obj.ex.alphabet'*dist;
        end
        
        function i_proj(obj,dist,mean)
            % I-project dist to the convex set {mean(dist)>=mean}
            obj.ex.iProj = dist;
            if obj.mean(obj.ex.iProj) >= mean
                return
            end
            
            % since the set is convex and alphabet is finite
            % the projection is the minimum tilt tilted distribution
            % tilt dist iteratively until error is small
            err = inf;
            while abs(err)>obj.ex.eps
                obj.ex.iProj = obj.ex.iProj.*exp(sign(err)*obj.ex.eps*obj.ex.alphabet);
                obj.ex.iProj = obj.ex.iProj/sum(obj.ex.iProj);
                err = mean-obj.mean(obj.ex.iProj);
            end
            
        end

        function m_proj(obj,dist,mean)
            % find M-projection of dist over set
            % of distributions with mean(dist)>= mean
            % 1. computing the mProj is a convex problem
            % 2. it is optimal to have support(mProj) as a subset
            % of support(dist) for the problem without the mean constraint,
            % ie. if dist was a finite sequence of nonnegative numbers,
            % unnormalized
            % 3. if mean(dist)>= mean, dist is optimal
            % to use cvx matlab package run cvx_setup.m
            cvx_begin quiet
            variable proj(obj.ex.alphabetSize)
            proj >= 0;
            sum(proj) == 1;
            obj.ex.alphabet'*proj >= mean;
            minimize(-dist'*log(proj))
            cvx_end
            obj.ex.mProj = proj;
        end
        
        function p = emp_prob_calc(obj,dist,emp_dist)
            % calculate the probability of observing emp_dist from dist in
            % sampleSize trials
            d2 = zeros(obj.ex.sampleSize,1);
            d3 = tril(ones(obj.ex.alphabetSize),-1)*obj.ex.sampleSize*emp_dist;
            d3(obj.ex.alphabetSize+1) = obj.ex.sampleSize;
            for i = 1:obj.ex.alphabetSize
                % debugging rounding error by round()
                d2(round(d3(i))+1:round(d3(i+1))) = 1:round(obj.ex.sampleSize*emp_dist(i));
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
            % realize dist sampleSize times and output the empirical dist if mean(dist) >=
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
            sampleDist = obj.ex.alphabet==sample;
            obj.ex.gmaDist = obj.ex.theta*obj.ex.gmaDist+sampleDist;
            obj.ex.gmaDist = obj.ex.gmaDist/sum(obj.ex.gmaDist);
        end
        
        function write_excel(obj)
            result = obj.ex.performance
            sheet = strcat(obj.ex.testNames{obj.ex.activeTestIndex{1}},'_',obj.ex.testTypes{obj.ex.activeTestIndex{2}})
            if strcmp(obj.ex.testNames{obj.ex.activeTestIndex{1}},'kl')
                % klMean = m, klRadius = r
                % m(1)r(1), m(1)r(2), ..., m(2)r(1), m(2)r(2), ...
                add = (obj.ex.activeTestIndex{3}(1)-1)*length(obj.ex.klRadiusRange)+obj.ex.activeTestIndex{3}(2);
            else
                add = obj.ex.activeTestIndex{3};
            end
            
            % convert number into A, B, ..., AA, AB, ... format used in
            % excel: 1>A, 10>J, 25>Y, 26>Z, 27>AA, 28>AB, ...
            v = dec2base(add-1,26)+(dec2base(add-1,26)>57)*10+(dec2base(add-1,26)<=57)*17-1;
            v(end) = v(end)+1;
            cellLetters = char(v);
            cellNumber = obj.ex.activeTestIndex{4};
            cell = char(cellLetters+string(cellNumber))
            xlswrite(obj.ex.excelFile,result,sheet,cell)
            obj.next()
        end
        
        function next(obj)
            testNameIndex = obj.ex.activeTestIndex{1};
            testTypeIndex = obj.ex.activeTestIndex{2};
            parameterIndex = obj.ex.activeTestIndex{3};
            repetition = obj.ex.activeTestIndex{4};
            if repetition < obj.ex.numberOfReps
                repetition = repetition+1;
            else
                repetition = 1;
                if strcmp(obj.ex.testNames{testNameIndex},'kl')
                    if parameterIndex(2) < length(obj.ex.klRadiusRange)
                        parameterIndex(2) = parameterIndex(2)+1;
                    else
                        parameterIndex(2) = 1;
                        if parameterIndex(1) < length(obj.ex.klMeanRange)
                            parameterIndex(1) = parameterIndex(1)+1;
                            obj.i_proj(obj.ex.unchangedDist,obj.ex.klMeanRange(parameterIndex(1)));
                        else
                            parameterIndex(1) = 1;
                            if testTypeIndex < length(obj.ex.testTypes)
                                testTypeIndex = testTypeIndex+1;
                            else
                                testTypeIndex = 1;
                                if testNameIndex < length(obj.ex.testNames)
                                    % other test have 1D parameters
                                    parameterIndex = 1;
                                    testNameIndex = testNameIndex+1;
                                else
                                    testNameIndex = 0;
                                end
                                
                            end
                            
                        end
                        
                    end
                    
                else
                    % assuming kl test is the first test
                    flag = 0;
                    for i = 2:length(obj.ex.testNames)
                        % assuming mean test is the second test
                        if i == 2
                            rangeName = 'meanMeanRange';
                        else
                            rangeName = strcat(obj.ex.testNames{obj.ex.activeTestIndex{1}},'ThrRange');
                        end
                        
                        flag = flag|(testNameIndex == i && parameterIndex < length(obj.ex.(rangeName)));
                    end
                    
                    if flag
                        parameterIndex = parameterIndex+1;
                    else
                        % let kl test be the first test
                        % because it has 2 parameters
                        parameterIndex = 1;
                        if testTypeIndex < length(obj.ex.testTypes)
                            testTypeIndex = testTypeIndex+1;
                            else
                                testTypeIndex = 1;
                                if testNameIndex < length(obj.ex.testNames)
                                    testNameIndex = testNameIndex+1;
                                else
                                    testNameIndex = 0;
                                end
                                
                        end
                        
                    end
                    
                end
                
            end
            
            obj.ex.activeTestIndex = {testNameIndex, testTypeIndex, parameterIndex, repetition};
            obj.ex.performance = -inf;
        end
        
        function read_excel(obj)
            for i = 1:length(obj.ex.testNames)
                for j = 1:length(obj.ex.testTypes)
                    read = xlsread(obj.ex.excelFile,strcat(obj.ex.testNames{i},'_',obj.ex.testTypes{j}));
                    obj.ex.performanceMean(strcat(obj.ex.testNames{i},'_',obj.ex.testTypes{j})) = mean(read);
                    obj.ex.performanceStd(strcat(obj.ex.testNames{i},'_',obj.ex.testTypes{j})) = std(read);
                end
                
            end
            
        end
        
        function plot(obj)
            figure
            hold on
            grid minor
            for i = 1:length(obj.ex.testNames)
                pfa = xlsread(obj.ex.excelFile,strcat(obj.ex.testNames{i},'_','pfa'));
                pmd = xlsread(obj.ex.excelFile,strcat(obj.ex.testNames{i},'_','pmd'));
                pfaMean = mean(pfa);
                pfaStd = std(pfa);
                % define probability of detection
                pdMean = 1-mean(pmd);
                pdStd = std(pmd);
                if strcmp(obj.ex.testNames{i},'kl')
                    for j = 1:length(obj.ex.klRadiusRange)
                        jump = length(obj.ex.klMeanRange);
                        errorbar(pfaMean(j:jump:end),pdMean(j:jump:end),pdStd(j:jump:end),pdStd(j:jump:end),pfaStd(j:jump:end),pfaStd(j:jump:end))
                    end
                    
                else
                    errorbar(pfaMean,pdMean,pdStd,pdStd,pfaStd,pfaStd)
                end
                
            end
            
        end
        
        %% change in single string tests
        function isChange = kl_is_change(obj,dist)
            % decide change if mean and kl distance is above threshold
            % 0/1 output
            % do the i-projection only ONCE for each kl mean
            % obj.i_proj(obj.ex.unchangedDist,obj.ex.klMeanRange(obj.ex.activeTestIndex{3}(1)));
            meanChange = obj.mean_change(dist);
            klChange = obj.kl_change(dist);
            isChange = and(meanChange,klChange);
        end
        
        function meanChange = mean_change(obj,dist)
            % decide whether the change in mean is above threshold
            % 0/1 output
            klMean = obj.ex.klMeanRange(obj.ex.activeTestIndex{3}(1));
            meanChange = obj.mean(dist) >= klMean;
        end
        
        function klChange = kl_change(obj,dist)
            % decide whether kl distance is above threshold, 0/1 output
            klRadius = obj.ex.klRadiusRange(obj.ex.activeTestIndex{3}(2));
            klChange = obj.kl_distance(dist,obj.ex.iProj) >= klRadius;
        end
        
        function isChange = mean_is_change(obj,dist)
            meanMean = obj.ex.meanMeanRange(obj.ex.activeTestIndex{3});
            isChange = obj.mean(dist) >= meanMean;
        end
        
        function isChange = lmp_is_change(obj,dist)
            d = obj.ex.sampleSize*dist'*log(obj.ex.iProj./obj.ex.unchangedDist)+log(dist'*(obj.ex.lmpDir./obj.ex.iProj));
            lmpThr = obj.ex.lmpThrRange(obj.ex.activeTestIndex{3});
            isChange = d >= lmpThr;
        end
        
        function isChange = glr_is_change(obj,dist)
            obj.m_proj(dist,obj.ex.beta)
            score = obj.emp_prob_calc(obj.ex.mProj,dist)/obj.emp_prob_calc(obj.ex.unchangedDist,dist);
            glrThr = obj.ex.glrThrRange(obj.ex.activeTestIndex{3});
            isChange = score >= glrThr;
        end
        
        %% repetetive false alarm tests
        function kl_pfa(obj)
            % probability of false alarm for the KL divergence test
            numberOfFalseAlarms = 0;
            for i = 1:obj.ex.pfaIt
                dist = obj.realize(obj.ex.unchangedDist);
                numberOfFalseAlarms = numberOfFalseAlarms+obj.kl_is_change(dist);
            end
            
            obj.ex.performance = numberOfFalseAlarms/obj.ex.pfaIt;
            obj.write_excel()
        end
        
        function mean_pfa(obj)
            numberOfFalseAlarms = 0;
            for i = 1:obj.ex.pfaIt
                dist = obj.realize(obj.ex.unchangedDist);
                numberOfFalseAlarms = numberOfFalseAlarms+obj.mean_is_change(dist);
            end
            
            obj.ex.performance = numberOfFalseAlarms/obj.ex.pfaIt;
            obj.write_excel()
        end
        
        function lmp_pfa(obj)
            numberOfFalseAlarms = 0;
            for i = 1:obj.ex.pfaIt
                dist = obj.realize(obj.ex.unchangedDist);
                numberOfFalseAlarms = numberOfFalseAlarms+obj.lmp_is_change(dist);
            end
            
            obj.ex.performance = numberOfFalseAlarms/obj.ex.pfaIt;
            obj.write_excel()
        end
        
        function glr_pfa(obj)
            numberOfFalseAlarms = 0;
            for i = 1:obj.ex.pfaIt
                dist = obj.realize(obj.ex.unchangedDist);
                numberOfFalseAlarms = numberOfFalseAlarms+obj.glr_is_change(dist);
            end
            
            obj.ex.performance = numberOfFalseAlarms/obj.ex.pfaIt;
            obj.write_excel()
        end
        
        %% repetetive misdetection tests
        function kl_pmd(obj)
            % probability of misdetection for the KL divergence test
            numberOfMisdetections = 0;
            for i = 1:obj.ex.pmdIt
                empDist = obj.realize(obj.ex.changedDist);
                numberOfMisdetections = numberOfMisdetections+(1-obj.kl_is_change(empDist));
                obj.ex.changedDist = obj.random_dist_mean(obj.ex.beta);
            end
            
            obj.ex.performance = numberOfMisdetections/obj.ex.pmdIt;
            obj.write_excel()
        end

        function mean_pmd(obj)
            numberOfMisdetections = 0;
            for i = 1:obj.ex.pmdIt
                obj.ex.changedDist = obj.random_dist_mean(obj.ex.beta);
                empDist = obj.realize(obj.ex.changedDist);
                numberOfMisdetections = numberOfMisdetections+(1-obj.mean_is_change(empDist));
            end
            
            obj.ex.performance = numberOfMisdetections/obj.ex.pmdIt;
            obj.write_excel()
        end
        
        function lmp_pmd(obj)
            numberOfMisdetections = 0;
            for i = 1:obj.ex.pmdIt
                obj.ex.changedDist = obj.random_dist_mean(obj.ex.beta);
                empDist = obj.realize(obj.ex.changedDist);
                numberOfMisdetections = numberOfMisdetections+(1-obj.lmp_is_change(empDist));
            end
            
            obj.ex.performance = numberOfMisdetections/obj.ex.pmdIt;
            obj.write_excel()
        end
        
        function glr_pmd(obj)
            numberOfMisdetections = 0;
            for i = 1:obj.ex.pmdIt
                obj.ex.changedDist = obj.random_dist_mean(obj.ex.beta);
                empDist = obj.realize(obj.ex.changedDist);
                numberOfMisdetections = numberOfMisdetections+(1-obj.glr_is_change(empDist));
            end
            
            obj.ex.performance = numberOfMisdetections/obj.ex.pmdIt;
            obj.write_excel()
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