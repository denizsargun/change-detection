classdef ipt < handle
    properties
        alpb % alphabet, representative letters for bins
        change % change, current detection status
        chnVac % changed vaccine, post-change vaccine coverage
        edges % edges, edges of the bins used in binning/ discretization
        emp % empirical distribution, empirical distribution of the window
        eps % epsilon, change in mean
        err % error, maximum allowable error in the mean of infromation projection
        iniVac % initial vaccine coverage, pre-change vaccine coverage
        iProj % information projection, the projection of uniform distribution to the convex set of distribution with mean >= threshold
        numBin % number of bins, number of bins used in binning/ discretization
        preMean % pre-change mean, pre-change mean of reported polio cases per million people
        ss % sample size, size of the window
        thr % threshold, threshold for cumulative deviation from mean and kl divergence
        win % window, effective window of samples
    end
    
    methods
        function obj = ipt(iniVac,meanFit,thr)
            obj.change = 0;
            obj.eps = 10;
            obj.numBin = 10;
            obj.iniVac = iniVac;
            obj.chnVac = obj.iniVac+obj.eps;
            obj.preMean = meanFit(obj.iniVac);
            % post-change mean < pre-change mean
            postMean = meanFit(obj.chnVac);
            % assume exponential distribution with mean obj.preMean
            edgeCdfs = (0:obj.numBin)'/obj.numBin;
            obj.edges = -obj.preMean*log(1-edgeCdfs);
            % formula for conditional mean in a bin
            % a is the representative letter for the bin
            % b and c are the bin edges and cons is the normalization constant
            % a&= \int_b^c x cons(1/\mu)\exp(-x/\mu)dx
            % &= cons((b+\mu)\exp(-b/\mu)-(c+\mu)\exp(-c/\mu))
            obj.alpb = zeros(obj.numBin,1);
            for i = 1:obj.numBin
                b = obj.edges(i);
                c = obj.edges(i+1);
                if c ~= Inf
                    obj.alpb(i) = obj.numBin*((b+obj.preMean)*exp(-b/obj.preMean)-(c+obj.preMean)*exp(-c/obj.preMean));
                else
                    obj.alpb(i) = obj.numBin*(b+obj.preMean)*exp(-b/obj.preMean);
                end
                
            end
            
            % if thr is input, use it, else, use the following
            if exist('thr','var')
                obj.thr = thr;
            else
                dum = (meanKl(obj.numBin)+meanKl2(obj.numBin))/2;
                klThr = dum/3;
                obj.thr = [postMean; klThr];
            end
            
            obj.err = min(obj.alpb(2:end)-obj.alpb(1:end-1))/10;
        end
        
        function obj = newSam(obj,samp)
            binN = discretize(samp,obj.edges);
            disSam = obj.alpb(binN);
            if sum(obj.preMean-[obj.win;disSam]) > 0
                obj.win = [obj.win; disSam];
                obj.ss = length(obj.win);
                obj.emp = (histcounts(obj.win,obj.edges)/obj.ss)';
                obj.isChange()
            else
                obj.win = [];
                obj.ss = 0;
                obj.emp = [];
            end
            
        end
        
        function obj = isChange(obj)
            % first check if cumulative drift from mean crosses threshold
            if sum(obj.preMean-obj.win) > obj.thr(1)
                m = obj.preMean-obj.thr(1)/obj.ss;
                % find most likely false alarm distribution
                obj.proj(m);
                klD = obj.kl();
                % if kl divergence from most likely false alarm is above threshold, alarm
                if klD > obj.thr(2)
                    obj.change = 1;
                else
                    obj.win = [];
                    obj.ss = 0;
                    obj.emp = [];
                end

            end
            
        end

        function obj = proj(obj,prjMean)
            % information project empirical distribution from obj.window to the convex set {myMean(dist) >= prjMean}
            obj.iProj = ones(obj.numBin,1)/obj.numBin;
            % since the set is convex and alphabet is finite
            % the projection is the minimum tilt tilted distribution
            % tilt dist iteratively until error is small
            meanErr = -inf;
            step = log(2)/(obj.alpb(end)-obj.alpb(1));
            while abs(meanErr) > obj.err
                obj.iProj = obj.iProj.*exp(sign(meanErr)*step*obj.alpb);
                obj.iProj = obj.iProj/sum(obj.iProj);
                old = meanErr;
                meanErr = prjMean-obj.myMean(obj.iProj);
                if sign(old) ~= sign(meanErr)
                    step = step/2;
                end
                
            end
            
        end
        
        function out = myMean(obj,dist)
            out = dist'*obj.alpb;
        end
        
        function out = kl(obj)
            % compute the kl divergence (base e) between empirical distribution
            % obj.window and information projection qStar
            nonzeroIndex = (obj.emp~=0);
            dum = obj.emp(nonzeroIndex);
            dum2 = obj.iProj(nonzeroIndex);
            llr = log(dum./dum2);
            out = dum'*llr;
        end
        
    end
    
end