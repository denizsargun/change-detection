classdef singleTcdPfa < handle
    properties
        bb
        ipt
        fma
        glrt
        m
        mAlpha
    end
    
    methods
        function obj = singleTcdPfa()
            obj.bb = betaBinom(10,2,3);
            obj.m = 20;
            obj.mAlpha = 200;
            obj.fma = fma(1,obj.m);
            %obj.glrt = glrt(obj.m);
            %obj.ipt = ipt(obj.m);
        end
        
        function ts = generateTimeSeries(obj)
            len = obj.mAlpha+obj.m-1;
            ts = obj.bb.getSample(len);
        end
        
        function isAlarm = run(obj)
            ts = obj.generateTimeSeries();
            isAlarm = zeros(3,1);
            isAlarm(1) = obj.fma.test(ts);
            %isAlarm(1) = obj.glrt.test(ts);
            %isAlarm(1) = obj.ipt.test(ts);
        end
        
    end
    
end