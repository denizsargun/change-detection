figure
plot(klM_mtbf(klM_mtbf<1e4),klM_delay(klM_mtbf<1e4),'r.')
grid minor
hold on
plot(meanM_mtbf(meanM_mtbf<1e4),meanM_delay(meanM_mtbf<1e4),'g.')
plot(glrM_mtbf(glrM_mtbf<1e4),glrM_delay(glrM_mtbf<1e4),'b.')

coefficients = polyfit(LOGklM_mtbf, LOGklM_delay, 1);
xFitKL = linspace(min(LOGklM_mtbf), max(LOGklM_mtbf), 1000);
yFitKL = polyval(coefficients , xFitKL);

coefficients = polyfit(LOGmeanM_mtbf, LOGmeanM_delay, 1);
xFitMEAN = linspace(min(LOGmeanM_mtbf), max(LOGmeanM_mtbf), 1000);
yFitMEAN = polyval(coefficients , xFitMEAN);

coefficients = polyfit(LOGglrM_mtbf, LOGglrM_delay, 1);
xFitGLR = linspace(min(LOGglrM_mtbf), max(LOGglrM_mtbf), 1000);
yFitGLR = polyval(coefficients , xFitGLR);

plot(exp(xFitKL),exp(yFitKL),'r')
plot(exp(xFitMEAN),exp(yFitMEAN),'g')
plot(exp(xFitGLR),exp(yFitGLR),'b')