classdef pmdT < handle
    properties
        dGau % discrete Gaussian pre-change
        dGPo % discrete Gaussian post-change
        dura % duration of the transient change
        iter % iteration
        itPo % iteration per post change distribution
        meth % method
        saLe % sample length
        thrs % threshold
        var0 % pre-change variance
        var1 % minimum post-change variance
        wind % window size
    end
    
    methods
        function obj = pmdT()
            obj.dura = 80;
            obj.iter = 1e5;
            obj.itPo = 1e2;
            obj.thrs = 10.^(-3:2)';
            obj.var0 = 1;
            obj.var1 = 2;
            obj.dGau = dGau(11,obj.var0);
            obj.wind = 20;
            
            obj.thrs = (-0.05:0.01:0.5)';
            obj.meth = fmaM(obj);

%             obj.thrs = (20:1:50)';
%             obj.meth = glrM(obj);

%             thr1 = (0.1:0.01:0.2)'; % positive
%             thr2 = 2.^(-3:0.5:2)';
%             [thr1,thr2] = meshgrid(thr1,thr2);
%             obj.thrs = [thr1(:) thr2(:)];
%             obj.meth = inpM(obj);
            
        end
        
        function timS = geTS(obj,chPo)
            if chPo == 1
                timS = obj.dGPo.samp(obj.iter,obj.saLe);
            else
                preC = obj.dGau.samp(obj.iter,chPo-1);
                posC = obj.dGPo.samp(obj.iter,obj.saLe-chPo+1);
                timS = [preC posC];
            end
            
        end
        
        function pmdE = repe(obj)
            nThr = size(obj.thrs,1); % number of thresholds
            pmdE = zeros(nThr,1); % pmd estimate
            for i = 1:nThr
                thre = obj.thrs(i,:); % single or multi-parameter
                pmdE(i) = 0;
                for j = 1:obj.itPo
                    disp([i,j])
                    para = obj.var1+exprnd(1);
                    obj.dGPo = dGau(11,para); %#ok<CPROP>
                    for chPo = 1:obj.wind
                        obj.saLe = obj.dura+chPo-1;
                        obj.saLe = obj.saLe-rem(obj.saLe,obj.wind);
                        timS = obj.geTS(chPo); % time series
                        pmdE(i) = max(pmdE(i),1-obj.meth.isAl(thre,timS));
                    end
                    
                end
                
            end
            
        end
        
    end
    
end
