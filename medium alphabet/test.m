classdef test < handle
    % execute kl divergence, mean, lmp and glr tests simultaneously

    properties
        util % utilities object
        klTest % kl div test object
        meanTest % mean test object
        lmpTest % locally most powerful test object
        glrTest % generalized likelihood ratio test object
        falseAlarm
        misdetection
        a % alphabet, in ascending order
        m % alphabet size
        n % sample size
        numberOfEmpDist % number of realizable empirical distributions
        q % unchanged distribution
        r % changed distribution
        beta
        eps % allowed error in I-projection
        theta % geometric moving average forgetting rate
        iProj % I-projection of
        mProj % M-projection of \tilde{p}, the empirical dist
        mProjIt
        % mProjLearningRate
        klParam % kl div test parameters, [klMean; klRadius]
        klPerf % [probability of false alarm; worst case probability of detection;
        % average probability of detection]
        meanParam
        meanPerf
        lmpParam % [lmpDir; lmpThr]
        lmpPerf
        glrParam
        glrPerf
        pfaIt % number of iterations for false alarm tests, [pfaItKlTest; pfaItMeanTest; pfaItLmpTest; pfaItGlrTest]
        pmdIt % number of random realizations of r
    end
    
    methods
        function obj = test(a,n,q,beta,theta,klParam,meanParam,lmpParam,glrParam,pfaIt,pmdIt,mProjIt)
            obj.a = sort(a);
            obj.m = length(obj.a);
            obj.n = n;
            obj.numberOfEmpDist = nchoosek(n+obj.m-1,obj.m-1);
            obj.q = q;
            obj.beta = beta;
            obj.eps = min(abs(a-circshift(a,1)))/1e5;
            obj.mProjIt = mProjIt;
            % obj.mProjLearningRate = 1/2;
            obj.util = util(obj);
            obj.util.i_proj(obj.q,obj.beta);
            obj.klParam = klParam;
            obj.klPerf = [-inf; -inf; -inf];
            obj.meanParam = meanParam;
            obj.meanPerf = [-inf; -inf; -inf];
            % obj.lmpParam = lmpParam;
            obj.lmpParam = [obj.iProj-obj.q;lmpParam(end)];
            obj.lmpPerf = [-inf; -inf; -inf];
            obj.glrParam = glrParam;
            obj.glrPerf = [-inf; -inf; -inf];
            obj.klTest = kl_test(obj);
            obj.meanTest = mean_test(obj);
            obj.lmpTest = lmp_test(obj);
            obj.glrTest = glr_test(obj);
            obj.pfaIt = pfaIt;
            obj.pmdIt = pmdIt;
            obj.falseAlarm = false_alarm(obj);
            obj.misdetection = misdetection(obj);
        end
        
    end
        
end