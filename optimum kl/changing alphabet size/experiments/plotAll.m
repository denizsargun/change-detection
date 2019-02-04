excelFile = 'experiment_N1M1_2019_02_03_17_52_03.xls';
klM_timeT11 = xlsread(excelFile,'klM_timeT');
meanM_timeT11 = xlsread(excelFile,'meanM_timeT');
lmpM_timeT11 = xlsread(excelFile,'lmpM_timeT');
glrM_timeT11 = xlsread(excelFile,'glrM_timeT');
excelFile = 'experiment_N1M2_2019_02_03_17_52_25.xls';
klM_timeT12 = xlsread(excelFile,'klM_timeT');
meanM_timeT12 = xlsread(excelFile,'meanM_timeT');
lmpM_timeT12 = xlsread(excelFile,'lmpM_timeT');
glrM_timeT12 = xlsread(excelFile,'glrM_timeT');
excelFile = 'experiment_N1M4_2019_02_03_17_52_46.xls';
klM_timeT14 = xlsread(excelFile,'klM_timeT');
meanM_timeT14 = xlsread(excelFile,'meanM_timeT');
lmpM_timeT14 = xlsread(excelFile,'lmpM_timeT');
glrM_timeT14 = xlsread(excelFile,'glrM_timeT');
excelFile = 'experiment_N2M1_2019_02_03_17_53_08.xls';
klM_timeT21 = xlsread(excelFile,'klM_timeT');
meanM_timeT21 = xlsread(excelFile,'meanM_timeT');
lmpM_timeT21 = xlsread(excelFile,'lmpM_timeT');
glrM_timeT21 = xlsread(excelFile,'glrM_timeT');
excelFile = 'experiment_N2M2_2019_02_03_17_54_41.xls';
klM_timeT22 = xlsread(excelFile,'klM_timeT');
meanM_timeT22 = xlsread(excelFile,'meanM_timeT');
lmpM_timeT22 = xlsread(excelFile,'lmpM_timeT');
glrM_timeT22 = xlsread(excelFile,'glrM_timeT');
excelFile = 'experiment_N2M4_2019_02_03_17_56_28.xls';
klM_timeT24 = xlsread(excelFile,'klM_timeT');
meanM_timeT24 = xlsread(excelFile,'meanM_timeT');
lmpM_timeT24 = xlsread(excelFile,'lmpM_timeT');
glrM_timeT24 = xlsread(excelFile,'glrM_timeT');
excelFile = 'experiment_N3M1_2019_02_03_17_58_29.xls';
klM_timeT31 = xlsread(excelFile,'klM_timeT');
meanM_timeT31 = xlsread(excelFile,'meanM_timeT');
lmpM_timeT31 = xlsread(excelFile,'lmpM_timeT');
glrM_timeT31 = xlsread(excelFile,'glrM_timeT');
excelFile = 'experiment_N3M2_2019_02_03_18_01_56.xls';
klM_timeT32 = xlsread(excelFile,'klM_timeT');
meanM_timeT32 = xlsread(excelFile,'meanM_timeT');
lmpM_timeT32 = xlsread(excelFile,'lmpM_timeT');
glrM_timeT32 = xlsread(excelFile,'glrM_timeT');
excelFile = 'experiment_N3M4_2019_02_03_18_05_17.xls';
klM_timeT34 = xlsread(excelFile,'klM_timeT');
meanM_timeT34 = xlsread(excelFile,'meanM_timeT');
lmpM_timeT34 = xlsread(excelFile,'lmpM_timeT');
glrM_timeT34 = xlsread(excelFile,'glrM_timeT');
excelFile = 'experiment_N4M1_2019_02_03_18_08_40.xls';
klM_timeT41 = xlsread(excelFile,'klM_timeT');
meanM_timeT41 = xlsread(excelFile,'meanM_timeT');
lmpM_timeT41 = xlsread(excelFile,'lmpM_timeT');
glrM_timeT41 = xlsread(excelFile,'glrM_timeT');
excelFile = 'experiment_N4M2_2019_02_03_18_31_40.xls';
klM_timeT42 = xlsread(excelFile,'klM_timeT');
meanM_timeT42 = xlsread(excelFile,'meanM_timeT');
lmpM_timeT42 = xlsread(excelFile,'lmpM_timeT');
glrM_timeT42 = xlsread(excelFile,'glrM_timeT');
excelFile = 'experiment_N4M4_2019_02_03_18_40_52.xls';
klM_timeT44 = xlsread(excelFile,'klM_timeT');
meanM_timeT44 = xlsread(excelFile,'meanM_timeT');
lmpM_timeT44 = xlsread(excelFile,'lmpM_timeT');
glrM_timeT44 = xlsread(excelFile,'glrM_timeT');

klM_time1 = [klM_timeT11; klM_timeT12; klM_timeT14];
klM_time2 = [klM_timeT21; klM_timeT22; klM_timeT24];
klM_time3 = [klM_timeT31; klM_timeT32; klM_timeT34];
klM_time4 = [klM_timeT41; klM_timeT42; klM_timeT44];
meanM_time1 = [meanM_timeT11; meanM_timeT12; meanM_timeT14];
meanM_time2 = [meanM_timeT21; meanM_timeT22; meanM_timeT24];
meanM_time3 = [meanM_timeT31; meanM_timeT32; meanM_timeT34];
meanM_time4 = [meanM_timeT41; meanM_timeT42; meanM_timeT44];
lmpM_time1 = [lmpM_timeT11; lmpM_timeT12; lmpM_timeT14];
lmpM_time2 = [lmpM_timeT21; lmpM_timeT22; lmpM_timeT24];
lmpM_time3 = [lmpM_timeT31; lmpM_timeT32; lmpM_timeT34];
lmpM_time4 = [lmpM_timeT41; lmpM_timeT42; lmpM_timeT44];
glrM_time1 = [glrM_timeT11; glrM_timeT12; glrM_timeT14];
glrM_time2 = [glrM_timeT21; glrM_timeT22; glrM_timeT24];
glrM_time3 = [glrM_timeT31; glrM_timeT32; glrM_timeT34];
glrM_time4 = [glrM_timeT41; glrM_timeT42; glrM_timeT44];

figure
subplot(2,2,1)
grid minor
hold on
plot([1 2 4], klM_time1(:,1),'black')
plot([1 2 4], klM_time1(:,2),'black')
plot([1 2 4], meanM_time1,'r')
plot([1 2 4], lmpM_time1,'g')
plot([1 2 4], glrM_time1,'b')
subplot(2,2,2)
grid minor
hold on
plot([1 2 4], klM_time2(:,1),'black')
plot([1 2 4], klM_time2(:,2),'black')
plot([1 2 4], meanM_time2,'r')
plot([1 2 4], lmpM_time2,'g')
plot([1 2 4], glrM_time2,'b')
subplot(2,2,3)
grid minor
hold on
plot([1 2 4], klM_time3(:,1),'black')
plot([1 2 4], klM_time3(:,2),'black')
plot([1 2 4], meanM_time3,'r')
plot([1 2 4], lmpM_time3,'g')
plot([1 2 4], glrM_time3,'b')
subplot(2,2,4)
grid minor
hold on
plot([1 2 4], klM_time4(:,1),'black')
plot([1 2 4], klM_time4(:,2),'black')
plot([1 2 4], meanM_time4,'r')
plot([1 2 4], lmpM_time4,'g')
plot([1 2 4], glrM_time4,'b')
