%% find the time shift for highest correlation between vaccination % and reports
turk = data('turkey');
rept = turk{1};
vacc = turk{2};
maxShft = max(rept.Time)-min(vacc.Time);
corr = zeros(maxShft,1);
samp = zeros(maxShft,1);
for i = 0:maxShft
    for j = 1:length(vacc.Time)
        year = vacc.Time(j);
        reptYear = year+i;
        ind = find(rept.Time == reptYear);
        if ~isempty(ind)
            corr = corr+;
            samp = samp+1;
        end
        
    end
    
end