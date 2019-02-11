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
subplot(2,2,1,'XScale','log','YScale','log')
grid minor
hold on
plot(2.^(1:10), [timeN1M1(1) timeN2M1(1) timeN3M1(1) timeN4M1(1) timeN5M1(1) timeN6M1(1) timeN7M1(1) timeN8M1(1) timeN9M1(1) timeN10M1(1)],'black')
plot(2.^(1:10), [timeN1M1(2) timeN2M1(2) timeN3M1(2) timeN4M1(2) timeN5M1(2) timeN6M1(2) timeN7M1(2) timeN8M1(2) timeN9M1(2) timeN10M1(2)],'black')
plot(2.^(1:10), [timeN1M1(3) timeN2M1(3) timeN3M1(3) timeN4M1(3) timeN5M1(3) timeN6M1(3) timeN7M1(3) timeN8M1(3) timeN9M1(3) timeN10M1(3)],'r')
plot(2.^(1:10), [timeN1M1(4) timeN2M1(4) timeN3M1(4) timeN4M1(4) timeN5M1(4) timeN6M1(4) timeN7M1(4) timeN8M1(4) timeN9M1(4) timeN10M1(4)],'g')
plot(2.^(1:10), [timeN1M1(5) timeN2M1(5) timeN3M1(5) timeN4M1(5) timeN5M1(5) timeN6M1(5) timeN7M1(5) timeN8M1(5) timeN9M1(5) timeN10M1(5)],'b')

subplot(2,2,2,'XScale','log','YScale','log')
grid minor
hold on
plot(2.^(1:10), [timeN1M2(1) timeN2M2(1) timeN3M2(1) timeN4M2(1) timeN5M2(1) timeN6M2(1) timeN7M2(1) timeN8M2(1) timeN9M2(1) timeN10M2(1)],'black')
plot(2.^(1:10), [timeN1M2(2) timeN2M2(2) timeN3M2(2) timeN4M2(2) timeN5M2(2) timeN6M2(2) timeN7M2(2) timeN8M2(2) timeN9M2(2) timeN10M2(2)],'black')
plot(2.^(1:10), [timeN1M2(3) timeN2M2(3) timeN3M2(3) timeN4M2(3) timeN5M2(3) timeN6M2(3) timeN7M2(3) timeN8M2(3) timeN9M2(3) timeN10M2(3)],'r')
plot(2.^(1:10), [timeN1M2(4) timeN2M2(4) timeN3M2(4) timeN4M2(4) timeN5M2(4) timeN6M2(4) timeN7M2(4) timeN8M2(4) timeN9M2(4) timeN10M2(4)],'g')
plot(2.^(1:10), [timeN1M2(5) timeN2M2(5) timeN3M2(5) timeN4M2(5) timeN5M2(5) timeN6M2(5) timeN7M2(5) timeN8M2(5) timeN9M2(5) timeN10M2(5)],'b')

subplot(2,2,3,'XScale','log','YScale','log')
grid minor
hold on
plot(2.^(1:10), [timeN1M4(1) timeN2M4(1) timeN3M4(1) timeN4M4(1) timeN5M4(1) timeN6M4(1) timeN7M4(1) timeN8M4(1) timeN9M4(1) timeN10M4(1)],'black')
plot(2.^(1:10), [timeN1M4(2) timeN2M4(2) timeN3M4(2) timeN4M4(2) timeN5M4(2) timeN6M4(2) timeN7M4(2) timeN8M4(2) timeN9M4(2) timeN10M4(2)],'black')
plot(2.^(1:10), [timeN1M4(3) timeN2M4(3) timeN3M4(3) timeN4M4(3) timeN5M4(3) timeN6M4(3) timeN7M4(3) timeN8M4(3) timeN9M4(3) timeN10M4(3)],'r')
plot(2.^(1:10), [timeN1M4(4) timeN2M4(4) timeN3M4(4) timeN4M4(4) timeN5M4(4) timeN6M4(4) timeN7M4(4) timeN8M4(4) timeN9M4(4) timeN10M4(4)],'g')
plot(2.^(1:10), [timeN1M4(5) timeN2M4(5) timeN3M4(5) timeN4M4(5) timeN5M4(5) timeN6M4(5) timeN7M4(5) timeN8M4(5) timeN9M4(5) timeN10M4(5)],'b')

subplot(2,2,4,'XScale','log','YScale','log')
grid minor
hold on
plot(2.^(1:10), [timeN1M8(1) timeN2M8(1) timeN3M8(1) timeN4M8(1) timeN5M8(1) timeN6M8(1) timeN7M8(1) timeN8M8(1) timeN9M8(1) timeN10M8(1)],'black')
plot(2.^(1:10), [timeN1M8(2) timeN2M8(2) timeN3M8(2) timeN4M8(2) timeN5M8(2) timeN6M8(2) timeN7M8(2) timeN8M8(2) timeN9M8(2) timeN10M8(2)],'black')
plot(2.^(1:10), [timeN1M8(3) timeN2M8(3) timeN3M8(3) timeN4M8(3) timeN5M8(3) timeN6M8(3) timeN7M8(3) timeN8M8(3) timeN9M8(3) timeN10M8(3)],'r')
plot(2.^(1:10), [timeN1M8(4) timeN2M8(4) timeN3M8(4) timeN4M8(4) timeN5M8(4) timeN6M8(4) timeN7M8(4) timeN8M8(4) timeN9M8(4) timeN10M8(4)],'g')
plot(2.^(1:10), [timeN1M8(5) timeN2M8(5) timeN3M8(5) timeN4M8(5) timeN5M8(5) timeN6M8(5) timeN7M8(5) timeN8M8(5) timeN9M8(5) timeN10M8(5)],'b')
end