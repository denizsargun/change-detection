classdef repeat < handle
    % coordinate number of repetetions for each test
    properties
        klMeanRange = (-0.57:0.1:0.33)'; % put 10 points for a nice plot
        klRadiusRange = 2.^(-10:1:-2)'; % put 5 points for a nice plot
        meanMeanRange = (-0.57:0.1:0.33)'; % put 10 points for a nice plot
        lmpThrRange = -2.^(0.5:0.15:2)'; % put 10 points for a nice plot
        glrThrRange = 2.^(4:0.5:4)'; % put 10 points for a nice plot
        a = [-1 0 1]';
        n = 100;
        q = 1/3*ones(3,1);
        beta = 1/3;
        pfaIt = 1e5;
        pmdIt = 1e5;
        mProjIt = 1e3;
        t % test object
        excelFileName = 'test_results.xlsx';
        testNames = [string('klTest'),string('meanTest'),string('lmpTest'),string('glrTest')]; % also the excel sheet names
        testTypes = [string('pfa');string('pmd')];
    end
    
    methods
        function obj = repeat()
            tic
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

            toc
            tic
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
            
            toc
            tic
            for i = 1:length(obj.lmpThrRange)
                    klParam = [0;0]; % dummy
                    meanParam = 0; % dummy
                    lmpParam = obj.lmpThrRange(i);
                    glrParam = 0; % dummy
                    obj.t = test(obj.a,obj.n,obj.q,obj.beta,klParam,meanParam,lmpParam,glrParam,obj.pfaIt,obj.pmdIt,obj.mProjIt);
                    obj.t.falseAlarm.run_pfa('lmp_test')
                    obj.xls_write(obj.t.lmpPerf(1),obj.testTypes(1),obj.testNames(3),lmpParam)
                    obj.t.misdetection.run_pmd('lmp_test')
                    obj.xls_write(obj.t.lmpPerf(2),obj.testTypes(2),obj.testNames(3),lmpParam)
            end
            
            toc
            tic
            for i = 1:length(obj.glrThrRange)
                    klParam = [0;0]; % dummy
                    meanParam = 0; % dummy
                    lmpParam = 0; % dummy
                    glrParam = obj.glrThrRange(i);
                    obj.t = test(obj.a,obj.n,obj.q,obj.beta,klParam,meanParam,lmpParam,glrParam,obj.pfaIt,obj.pmdIt,obj.mProjIt);
                    obj.t.falseAlarm.run_pfa('glr_test')
                    obj.xls_write(obj.t.glrPerf(1),obj.testTypes(1),obj.testNames(4),glrParam)
                    obj.t.misdetection.run_pmd('glr_test')
                    obj.xls_write(obj.t.glrPerf(2),obj.testTypes(2),obj.testNames(4),glrParam)
            end
            
            toc
            obj.xls_stamp()
        end
        
        function xls_write(obj,result,testType,testName,parameter)
            % write results to an excel spreadsheet
            if testName == obj.testNames(1)
                if testType == obj.testTypes(1)
                    d1 = num2str(find(parameter(1) == obj.klMeanRange)+1);
                    d2 = char(find(parameter(2) == obj.klRadiusRange)+65); % turning into ascii
                    cellName = strcat(d2,d1);
                else
                    d1 = num2str(find(parameter(1) == obj.klMeanRange)+15);
                    d2 = char(find(parameter(2) == obj.klRadiusRange)+65); % turning into ascii
                    cellName = strcat(d2,d1);
                end
            
            elseif testName == obj.testNames(2)
                if testType == obj.testTypes(1)
                    d = num2str(find(parameter(1) == obj.meanMeanRange)+1);
                    cellName = strcat('B',d);
                else
                    d = num2str(find(parameter(1) == obj.meanMeanRange)+1);
                    cellName = strcat('C',d);
                end
                
            elseif testName == obj.testNames(3)
                if testType == obj.testTypes(1)
                    d = num2str(find(parameter(1) == obj.lmpThrRange)+1);
                    cellName = strcat('B',d);
                else
                    d = num2str(find(parameter(1) == obj.lmpThrRange)+1);
                    cellName = strcat('C',d);
                end
                
            else % test name is 'glrTest'
                if testType == obj.testTypes(1)
                    d = num2str(find(parameter(1) == obj.glrThrRange)+1);
                    cellName = strcat('B',d);
                else
                    d = num2str(find(parameter(1) == obj.glrThrRange)+1);
                    cellName = strcat('C',d);
                end
                
            end
            
            xlswrite(obj.excelFileName,result,char(testName),cellName)
%             result
            testName
            cellName
        end
        
        function xls_stamp(obj)
            date = clock;
            date(6) = round(date(6));
            dateName = mat2str(date);
            dateName = dateName(2:end-1);
            dateName = strrep(dateName,' ','_');
            newName = strcat('test_results','_',dateName,'.xlsx')
            movefile(obj.excelFileName,newName)
            xlswrite(newName,{'kl test mean range'},1,'A1')
            xlswrite(newName,obj.klMeanRange(1),1,'B1')
            xlswrite(newName,obj.klMeanRange(end),1,'C1')
            xlswrite(newName,{'kl test radius range'},1,'A2')
            xlswrite(newName,obj.klRadiusRange(1),1,'B2')
            xlswrite(newName,obj.klRadiusRange(end),1,'C2')
            xlswrite(newName,{'mean test mean range'},1,'A3')
            xlswrite(newName,obj.meanMeanRange(1),1,'B3')
            xlswrite(newName,obj.meanMeanRange(end),1,'C3')
            xlswrite(newName,{'lmp test threshold range'},1,'A4')
            xlswrite(newName,obj.lmpThrRange(1),1,'B4')
            xlswrite(newName,obj.lmpThrRange(end),1,'C4')
            xlswrite(newName,{'glr test threshold range'},1,'A5')
            xlswrite(newName,obj.glrThrRange(1),1,'B5')
            xlswrite(newName,obj.glrThrRange(end),1,'C5')
            xlswrite(newName,{'alphabet'},1,'A6')
            for i = 1:obj.t.m
                str = strcat(char('B'-1+i),'6');
                xlswrite(newName,obj.a(i),1,str)
            end
            
            xlswrite(newName,{'n'},1,'A7')
            xlswrite(newName,obj.n,1,'B7')
            xlswrite(newName,{'q'},1,'A8')
            for i = 1:obj.t.m
                str = strcat(char('B'-1+i),'8');
                xlswrite(newName,obj.q(i),1,str)
            end
            
            xlswrite(newName,{'beta'},1,'A9')
            xlswrite(newName,obj.beta,1,'B9')
            xlswrite(newName,{'pfaIt'},1,'A10')
            xlswrite(newName,obj.pfaIt,1,'B10')
            xlswrite(newName,{'pmdIt'},1,'A11')
            xlswrite(newName,obj.pmdIt,1,'B11')
            xlswrite(newName,{'mProjIt'},1,'A12')
            xlswrite(newName,obj.mProjIt,1,'B12')
        end
        
    end
        
end
