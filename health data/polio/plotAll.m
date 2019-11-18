for i = 1:201
    i
    m = 5;
    n = 5;
    if rem(i,m*n) == 1
        figure
    end
    
    region = regions{i};
    dum = data(region);
    localVpo = dum{1};
    localRpm = dum{3};
    num = rem(i,m*n)+m*n*(rem(i,m*n)==0);
    subplot(m,n,num)
    yyaxis left
    plot(localVpo)
    ylim([0,100])
    ylabel('')
    yyaxis right
    plot(localRpm)
    title(region)
    xlabel('')
    ylabel('')
    grid minor
end