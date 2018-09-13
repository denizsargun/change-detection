classdef experiment < handle
    % hold utility object and variables
    % run algorithm
    % plot results
    properties
        utility % utility toolbox
        klMeanRange
        klRadiusRange
        meanMeanRange
        lmpThrRange
        glrThrRange
        alphabet
        alphabetSize
        sampleSize
        numberOfEmpDist
        unchangedDist
        changedDist
        beta
        eps
        theta
        iProj
        mProj
        pfaIt
        pmdIt
        mProjIt
        excelFileName
        testNames
        testTypes
        performance
    end
    
    methods
        function obj = experiment()
            utility.setup()
        end
        
    end
    
end