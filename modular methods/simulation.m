classdef simulation < handle
    % nO = number Of
    properties
        problem
        tools
    end
    
    methods
        function obj = simulation()
            obj.problem = problem(alphabet,unchangedDist,beta);
            % initalize solutions
            solutionSchemes = ["kl" "mean" "lmp" "glr"];
            performanceMetric = ["pfa" "pmd"];
            nOSolutions = length(solutionSchemes);
            obj.solutions = cell(nOSolutions,1);
            for i = 1:nOSolutions
                obj.solutions{i} = solution(...
                    obj.problem(),solutionSchemes(i),...
                    performanceMetric(i));
            end
            
            % setup cvx solver
            % http://cvxr.com/cvx/download/ (CVX Research Inc.)
            % do the cvx setup only ONCE at the beginning of opening a
            % Matlab command window
            cvxFolder = '\\home2.coeit.osu.edu\s\sargun.1\ECE\Desktop\cvx';
            cvxSetupFile = 'cvx_setup.m';
            run(fullfile(cvxFolder,cvxSetupFile))
        end
        
    end
    
end