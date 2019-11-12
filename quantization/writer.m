 classdef writer < handle
    properties
        ex
        storageFile
    end
    
    methods
        function obj = writer(experiment)
            obj.ex = experiment;
            obj.storageFile = obj.ex.storageFile;
        end
        
        function write(obj,output,method,testName,i)
            sheetName = strcat(method.methodName,'_',testName);
            v = dec2base(i-1,26)+(dec2base(i-1,26)>57)*10 ...
                +(dec2base(i-1,26)<=57)*17-1;
            v(end) = v(end)+1;
            cellLetters = char(v);
            cellNumber = 1;
            cell = char(cellLetters+string(cellNumber));
            % xlswrite()
            % or
            xlwrite(obj.storageFile,output,sheetName,cell);
            % or
            % csvwrite()
        end
        
    end
    
end