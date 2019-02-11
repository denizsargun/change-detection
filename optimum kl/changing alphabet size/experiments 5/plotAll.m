function plotAll()
xlsFiles = dir('*.xls');
for i = 1:length(xlsFiles)
    excelFile = xlsFiles(i).name;
    split = strsplit(excelFile,'_');
    parametersString = split{2};
    klM_time = xlsread(excelFile,'klM_timeT');
    meanM_time = xlsread(excelFile,'meanM_timeT');
    lmpM_time = xlsread(excelFile,'lmpM_timeT');
    glrM_time = xlsread(excelFile,'glrM_timeT');
    string = strcat('time',parametersString,' = [klM_time meanM_time lmpM_time glrM_time];');
    eval(string)
end

figure
grid minor
hold on
plot(2.^(3:3:12), [timeN9M10(1) timeN6M10(1) timeN9M10(1) timeN12M10(1)],'black')
plot(2.^(3:3:12), [timeN9M10(2) timeN6M10(2) timeN9M10(2) timeN12M10(2)],'black')
plot(2.^(3:3:12), [timeN9M10(3) timeN6M10(3) timeN9M10(3) timeN12M10(3)],'r')
plot(2.^(3:3:12), [timeN9M10(4) timeN6M10(4) timeN9M10(4) timeN12M10(4)],'g')
plot(2.^(3:3:12), [timeN9M10(5) timeN6M10(5) timeN9M10(5) timeN12M10(5)],'b')
end