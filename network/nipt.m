classdef nipt < handle
    % network information projection test
    
    properties
        cs % threshold
        cd = inf % satisfies all bounds
        cutHor % N or T in proofs
        effWin = 0
        drift = -0.4
        ssa = [] % matrix of sum of samples at each sensor, size = effWin x 3
        ssq = [] % matrix of sum of squares at each sensor, size = effWin x 3
        stop = 0 % stopping time
        stopFlag = 0
    end
    
    methods
        function obj = nipt(cs)
            obj.cs = cs;
            obj.cutHor = (1-0.2)*obj.cs/abs(obj.drift); % rho(arl) = 0.2
        end
        
        function obj = newSample(obj,netSample)
            if obj.stopFlag == 1
                return
            end
            
            % newSample is 1x3
            obj.effWin = obj.effWin+1;
            obj.ssa = [obj.ssa; zeros(1,3)];
            ssaUp = repmat(netSample,obj.effWin,1);
            obj.ssa = obj.ssa+ssaUp;
            obj.ssq = [obj.ssq; zeros(1,3)];
            ssqUp = repmat(netSample.^2,obj.effWin,1);
            obj.ssq = obj.ssq+ssqUp;
            scaling = repmat((obj.effWin:-1:1)',1,3);
            statMat = obj.ssq-obj.ssa.^2./scaling-scaling;
            statVec = sum(statMat,2)+(obj.effWin:-1:1)'*obj.drift;
            [stat,ind] = max([statVec;0]);
            if stat >= obj.cs
                if obj.effWin-ind+1 > obj.cutHor
                    obj.stop = obj.stop+obj.effWin;
                    obj.effWin = 0;
                    obj.ssa = [];
                    obj.ssq = [];
                else
                    obj.stop = obj.stop+obj.effWin;
                    obj.stopFlag = 1;
                end
                
            end
            
        end
        
        function reset(obj)
            obj.stop = 0;
            obj.effWin = 0;
            obj.ssa = [];
            obj.ssq = [];
            obj.stopFlag = 0;
        end
        
    end
    
end