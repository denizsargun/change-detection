% load('waddTest.mat')
timeHor = 1e3;
pre = prechange;
csList = (4:4:40)';
csLen = length(csList);
outputArg = zeros(csLen,6,25,25);
startTime = tic;
for i = 1:csLen
    myNipt = nipt(csList(i));
    for j = 1:6
        for k = 1:25
            for l = 1:25
                stopSum = 0;
                for m = 1:50
                    n = 1;
                    while (myNipt.stopFlag == 0 && n <= timeHor)
                        changed = waddTest.data(j,k,l,m,n);
                        unchanged = pre.sample(2);
                        sams = [changed;unchanged]; % samples
                        myNipt.newSample(sams');
                        [i,j,k,l,m,n]
                        a = ((i-1)*6*25*25*50*1e3+(j-1)*25*25*50*1e3+(k-1)*25*50*1e3+(l-1)*50*1e3+(m-1)*1e3+n)/(10*6*25*25*50*1e3);
                        passedTime = toc;
                        [a,toc/a*(1-a)]
                        n = n+1;
                    end
                    
                    if myNipt.stopFlag == 0
                        stop = timeHor;
                    else
                        stop = myNipt.stop;
                    end
                    
                    stopSum = stopSum+stop;
                    myNipt.reset
                end
                
                outputArg(i,j,k,l) = stopSum/50;
            end
            
        end
        
    end
    
end