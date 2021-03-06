%% read data from 3 csv files
% vpo = {region, code, year, coverage percentage} of polio vaccine coverage of one-year-olds
vpo = textscan(fileread('polio-vaccine-coverage-of-one-year-olds.csv'),'%s %s %f %f', 'delimiter', ',', 'HeaderLines', 1);
% nrp = {region, code, year, number of reported cases} of number of reported polio cases
nrp = textscan(fileread('the-number-of-reported-paralytic-polio-cases.csv'),'%s %s %f %f', 'delimiter', ',', 'HeaderLines', 1);
% rpm = {region, code, year, cases} of reported polio cases per 1 million people
rpm = textscan(fileread('reported-paralytic-polio-cases-per-1-million-people.csv'),'%s %s %f %f', 'delimiter', ',', 'HeaderLines', 1);
% vpo, nrp and rpm have equal sets of regions
% union(union(setdiff(vpo{1},nrp{1}), setdiff(nrp{1},rpm{1})),setdiff(rpm{1},vpo{1})) is empty
%%
data = containers.Map();
for i = 1:length(vpo{1})
    if ~any(strcmp(data.keys,vpo{1}{i}))
        ts = timeseries(vpo{4}(i),vpo{3}(i),'Name','polio vaccine coverage of one-year-olds');
        ts.TimeInfo.Units = 'Year';
        data(vpo{1}{i}) = ts;
    else
        data(vpo{1}{i}) = addsample(data(vpo{1}{i}),'Data',vpo{4}(i),'Time',vpo{3}(i));
    end

end

regions = data.keys;
for i = 1:length(nrp{1})
    if length(data(nrp{1}{i})) == 1
        dum = cell(2,1);
        dum{1} = data(nrp{1}{i});
        ts = timeseries(nrp{4}(i),nrp{3}(i),'Name','number of reported polio cases');
        ts.TimeInfo.Units = 'Year';
        dum{2} = ts;
        data(nrp{1}{i}) = dum;
    else
        dum = data(nrp{1}{i});
        dum{2} = addsample(dum{2},'Data',nrp{4}(i),'Time',nrp{3}(i));
        data(nrp{1}{i}) = dum;
    end
    
end

for i = 1:length(rpm{1})
    if length(data(rpm{1}{i})) == 2
        dum = cell(3,1);
        dum(1:2) = data(rpm{1}{i});
        ts = timeseries(rpm{4}(i),rpm{3}(i),'Name','reported polio cases per 1 million people');
        ts.TimeInfo.Units = 'Year';
        dum{3} = ts;
        data(rpm{1}{i}) = dum;
    else
        dum = data(rpm{1}{i});
        dum{3} = addsample(dum{3},'Data',rpm{4}(i),'Time',rpm{3}(i));
        data(rpm{1}{i}) = dum;
    end
    
end

%% find the time shift for highest cross-correlation between vaccination % and reports
% l = length(regions);
% minCorr = [];
% for i = 1:l
%     region = data(regions{i});
%     vacc = region{1};
%     rept = region{2};
%     meanV = mean(region{1}.Data);
%     meanR = mean(region{2}.Data);
%     maxShft = max(rept.Time)-min(vacc.Time);
%     ccrr = zeros(maxShft+1,1);
%     samp = zeros(maxShft+1,1);
%     for j = 0:maxShft
%         for k = 1:length(vacc.Time)
%             year = vacc.Time(k);
%             reptYear = year+j;
%             ind = find(rept.Time == reptYear);
%             if ~isempty(ind)
%                 ccrr(j+1) = ccrr(j+1)+(vacc.Data(k)-meanV)*(rept.Data(ind)-meanR);
%                 samp(j+1) = samp(j+1)+1;
%             end
% 
%         end
% 
%     end
% 
%     [~,minInd] = min(ccrr./samp);
%     minCorr = [minCorr; minInd-1];
% end
% 
% % 114 country/region out of 201 have minimum at 0 year time shift
%%
vacRep = containers.Map('KeyType','double','ValueType','any');
% observation of polio reports/ mil. ppl for a given vaccination percentage of 1 y.o. over all regions, years
for i = 1:length(regions)
    region = regions{i};
    dum = data(region);
    localVpo = dum{1};
    localRpm = dum{3};
    for j = 1:length(localVpo.Time)
        ind = find(localRpm.Time == localVpo.Time(j));
        if ~isempty(ind)
            keys = vacRep.keys;
            if ~any([keys{:}] == localVpo.Data(j))
                vacRep(localVpo.Data(j)) = localRpm.Data(ind);
            else
                vacRep(localVpo.Data(j)) = [vacRep(localVpo.Data(j)); localRpm.Data(ind)];
            end
        
        end
        
    end
    
end

%%
keys = vacRep.keys;
l = length(keys);
dists = containers.Map('KeyType','double','ValueType','double');
% exponential distribution fit to histogram of polio reports/ mil. ppl. vs vaccination percentage of 1 y.o.
for i = 1:l
    key = keys(i);
    dum = fitdist(vacRep(key{1}),'Exponential');
    dists(key{1}) = dum.mu;
end

%%
v = values(dists,dists.keys);
v = [v{:}]';
k = dists.keys;
k = [k{:}]';
meanFit = fit(k,v,'exp1');
%% apply the ipt to random regions
% m = 3;
% n = 3;
% perm = randperm(201);
% r = sort(perm(1:m*n));
% hf = figure;
% for i = 1:m*n
%     i
%     region = regions{r(i)};
%     dum = data(region);
%     localVpo = dum{1};
%     localRpm = dum{3};
%     iniVac = localVpo.Data(1);
%     changePoint = localVpo.Time(find(localVpo.Data > iniVac+10,1));
%     if isempty(changePoint)
%         changePoint = Inf;
%     end
%     
%     test = ipt(iniVac,meanFit);
%     l = length(localRpm.Data);
%     for t = 1:l
%         sam = localRpm.Data(t);
%         test.newSam(sam)
%         if test.change
%             break
%         end
% 
%     end
% 
%     t
%     if ~test.change
%         alarmPoint = Inf;
%     else
%         alarmPoint = localRpm.Time(t);
%     end
%     
%     num = rem(i,m*n)+m*n*(i==m*n);
%     ha = subplot(m,n,num);
%     yyaxis left
%     plot(localVpo)
%     ylim([0,100])
%     ylabel('')
%     yyaxis right
%     plot(localRpm)
%     xlim([1980,2015])
%     title(region)
%     xlabel('')
%     ylabel('')
%     grid minor
%     % text = "first year is " + localVpo.Time(1) + newline + "initial vaccine coverage percentage is " + iniVac + newline + "change point is " + changePoint + newline + "alarm year is " + alarmPoint;
%     if alarmPoint >= changePoint
%         delay = alarmPoint-changePoint;
%         text = "delay = " + delay;
%     else
%         text = "false alarm";
%     end
%     
%     arrayfun(@(x) pbaspect(x, [2 1 1]), ha);
%     drawnow;
%     pos = arrayfun(@plotboxpos, ha, 'uni', 0);
%     dim = cellfun(@(x) x.*[1 1 0.5 0.5], pos, 'uni',0);
%     annotation(hf,'textbox',dim{1},'String',join(text),'vert', 'bottom','FitBoxToText','on','FontSize',10)
% end

%%
l1 = length(regions);
meanThrParams = (0:0.25:1)';
klThrParams = 2.^(-3:2:3)';
l2 = length(meanThrParams);
l3 = length(klThrParams);
delay = zeros(l2,l3,l1);
runLength = zeros(l2,l3,l1);
total = l1*l2*l3;
chrono = tic;

for i = 1:l2
    for j = 1:l3
        for k = 1:l1
            myTime = toc(chrono);
            elapsed = (i-1)*l3*l1+(j-1)*l1+k;
            remainingTime = myTime/elapsed*(total-elapsed)
            region = regions{k};
            dum = data(region);
            localVpo = dum{1};
            localRpm = dum{3};
            iniVac = localVpo.Data(1);
            changePoint = localVpo.Time(find(localVpo.Data > iniVac+10,1));
            if isempty(changePoint)
                changePoint = Inf;
            end
            
            test = ipt(iniVac,meanFit);
            test.thr(1) = (1-meanThrParams(i))*test.thr(1)+(meanThrParams(i))*test.alpb(end);
            test.thr(2) = klThrParams(j)*test.thr(2);
            l4 = length(localRpm.Data);
            for t = 1:l4
                sam = localRpm.Data(t);
                test.newSam(sam);
                if test.change
                    break
                end

            end
            
            alarmPoint = localRpm.Time(t);
            if alarmPoint >= changePoint
                delay(i,j,k) = alarmPoint-changePoint;
            else
                runLength(i,j,k) = alarmPoint-localRpm.Time(1)+1;
            end
            
        end
        
    end
    
end

%%
figure
hold on
for i = 1:l2 % rgbkm
    for j = 1:l3 % *.o+
        delayLocal = delay(i,j,:);
        runLengthLocal = runLength(i,j,:);
        mask = find(runLengthLocal);
        mask2 = find(runLengthLocal == 0);
        x = mean(runLengthLocal(mask));
        y = mean(delayLocal(mask2));
        % y = max(delayLocal(mask2));
        % plot(x,y,'r*')
    end
    
end