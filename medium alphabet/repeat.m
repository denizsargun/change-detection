classdef repeat < handle
    % coordinate number of repetetions for each test
    properties
        klMeanRange = (0.1:0.05:0.4)';
        klRadiusRange = 2.^(-9:0.5:-3)';
        meanMeanRange = (0.1:0.05:0.4)';
        lmpThrRange = (-2:0.5:5);
        glrThrRange = 2.^(1:0.5:10)';
        a = [-1 0 1]';
        n = 50;
        q = 1/3*ones(3,1);
        beta = 1/4;
        pfaIt = 1e5;
        pmdIt = 1e5;
        mProjIt = 1e2;
        t % test object
        excelFileName = 'test_results.xlsx';
        testNames = [string('klTest'),string('meanTest'),string('lmpTest'),string('glrTest')]; % also the excel sheet names
        testTypes = [string('pfa');string('pmd')];
    end
    
    methods
        function obj = repeat()
            for i = 1:length(obj.klMeanRange)
                for j = 1:length(obj.klRadiusRange)
                    klParam = [obj.klMeanRange(i);obj.klRadiusRange(j)];
                    meanParam = 0; % dummy
                    lmpParam = 0; % dummy
                    glrParam = 0; % dummy
                    obj.t = test(obj.a,obj.n,obj.q,obj.beta,klParam,meanParam,lmpParam,glrParam,obj.pfaIt,obj.pmdIt,obj.mProjIt);
                    obj.t.falseAlarm.run_pfa('kl_test')
                    obj.xls_write(obj.t.klPerf(1),obj.testTypes(1),obj.testNames(1),klParam)
                    obj.t.misdetection.run_pmd('kl_test')
                    obj.xls_write(obj.t.klPerf(2),obj.testTypes(2),obj.testNames(1),klParam)
                end
                
            end

            for i = 1:length(obj.meanMeanRange)
                    klParam = [0;0]; % dummy
                    meanParam = obj.meanMeanRange(i);
                    lmpParam = 0; % dummy
                    glrParam = 0; % dummy
                    obj.t = test(obj.a,obj.n,obj.q,obj.beta,klParam,meanParam,lmpParam,glrParam,obj.pfaIt,obj.pmdIt,obj.mProjIt);
                    obj.t.falseAlarm.run_pfa('mean_test')
                    obj.xls_write(obj.t.meanPerf(1),obj.testTypes(1),obj.testNames(2),meanParam)
                    obj.t.misdetection.run_pmd('mean_test')
                    obj.xls_write(obj.t.meanPerf(2),obj.testTypes(2),obj.testNames(2),meanParam)
            end
            
            for i = 1:length(obj.lmpThrRange)
                    klParam = [0;0]; % dummy
                    meanParam = 0;
                    lmpParam = obj.lmpThrRange(i); % dummy
                    glrParam = 0; % dummy
                    obj.t = test(obj.a,obj.n,obj.q,obj.beta,klParam,meanParam,lmpParam,glrParam,obj.pfaIt,obj.pmdIt,obj.mProjIt);
                    obj.t.falseAlarm.run_pfa('lmp_test')
                    obj.xls_write(obj.t.lmpPerf(1),obj.testTypes(1),obj.testNames(3),lmpParam)
                    obj.t.misdetection.run_pmd('lmp_test')
                    obj.xls_write(obj.t.lmpPerf(2),obj.testTypes(2),obj.testNames(3),lmpParam)
            end
            
            for i = 1:length(obj.glrThrRange)
                    klParam = [0;0]; % dummy
                    meanParam = 0;
                    lmpParam = 0; % dummy
                    glrParam = obj.glrThrRange(i); % dummy
                    obj.t = test(obj.a,obj.n,obj.q,obj.beta,klParam,meanParam,lmpParam,glrParam,obj.pfaIt,obj.pmdIt,obj.mProjIt);
                    obj.t.falseAlarm.run_pfa('glr_test')
                    obj.xls_write(obj.t.glrPerf(1),obj.testTypes(1),obj.testNames(4),glrParam)
                    obj.t.misdetection.run_pmd('glr_test')
                    obj.xls_write(obj.t.glrPerf(2),obj.testTypes(2),obj.testNames(4),glrParam)
            end
            
        end
        
        function xls_write(obj,result,testType,testName,parameter)
            % write results to an excel spreadsheet
            if testName == obj.testNames(1)
                if testType == obj.testTypes(1)
                    d1 = num2str(find(parameter(1) == obj.klMeanRange)+1);
                    d2 = char(find(parameter(2) == obj.klRadiusRange)+65); % turning into ascii
                    cellName = strcat(d2,d1);
                else
                    d1 = num2str(find(parameter(1) == obj.klMeanRange)+10);
                    d2 = char(find(parameter(2) == obj.klRadiusRange)+65); % turning into ascii
                    cellName = strcat(d2,d1);
                end
            
            elseif testName == obj.testNames(2)
                if testType == obj.testTypes(1)
                    d = num2str(find(parameter(1) == obj.meanMeanRange)+1);
                    cellName = strcat('B',d);
                else
                    d = num2str(find(parameter(1) == obj.klMeanRange)+1);
                    cellName = strcat('C',d);
                end
                
            elseif testName == obj.testNames(3)
                if testType == obj.testTypes(1)
                    d = num2str(find(parameter(1) == obj.meanMeanRange)+1);
                    cellName = strcat('B',d);
                else
                    d = num2str(find(parameter(1) == obj.klMeanRange)+1);
                    cellName = strcat('C',d);
                end
                
            else % test name is 'glrTest'
                if testType == obj.testTypes(1)
                    d = num2str(find(parameter(1) == obj.meanMeanRange)+1);
                    cellName = strcat('B',d);
                else
                    d = num2str(find(parameter(1) == obj.klMeanRange)+1);
                    cellName = strcat('C',d);
                end
                
            end
            
            xlswrite(obj.excelFileName,result,char(testName),cellName)
            result
            testName
            cellName
        end
        
    end
        
end