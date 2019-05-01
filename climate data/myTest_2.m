M = xlsread('market-equity-sorted-daily.xls');
returns = M(:,4:6); % small, mid, large cap
dates = M(:,1)+(M(:,2)-1)/12+M(:,3)/30;

binEdges1 = [-inf; -1.13; -0.55; -0.26; -0.06; 0.11; 0.27; 0.44; 0.67; ...
    1.1; inf];
binEdges2 = [-inf; -1.09; -0.55; -0.26; -0.06; 0.10; 0.26; 0.43; 0.66; ...
    1.07; inf];
binEdges3 = [-inf; -1.02; -0.55; -0.27; -0.09; 0.07; 0.22; 0.40; 0.63; ...
    1.05; inf];
reps = zeros(10,3);
for i = 1:10
    reps(i,1) = mean(returns((binEdges1(i)<=returns(:,1))&(returns(:,1)<binEdges1(i+1)),1));
    reps(i,2) = mean(returns((binEdges2(i)<=returns(:,2))&(returns(:,2)<binEdges2(i+1)),2));
    reps(i,3) = mean(returns((binEdges3(i)<=returns(:,3))&(returns(:,3)<binEdges3(i+1)),3));
end

quantReturns = zeros(size(returns));
[~,quantReturns(:,1)] = quantiz(returns(:,1),binEdges1(2:end-1),reps(:,1));
[~,quantReturns(:,2)] = quantiz(returns(:,2),binEdges2(2:end-1),reps(:,2));
[~,quantReturns(:,3)] = quantiz(returns(:,3),binEdges3(2:end-1),reps(:,3));

meanThr = mean(quantReturns)-0.2*std(quantReturns);
klThr = 1e1;
movSumQuant = movsum(quantReturns,130,1,'Endpoints','discard')/130;
rolSumQuant = movSumQuant(1:130:end,:);
iProj1 = i_proj(reps(:,1),1/10*ones(10,1),meanThr(1));
iProj2 = i_proj(reps(:,2),1/10*ones(10,1),meanThr(2));
iProj3 = i_proj(reps(:,3),1/10*ones(10,1),meanThr(3));
rolDistn = zeros(floor(length(returns)/130),3);
for timeSt = 1:130:length(returns)-130
    empObs1 = histcounts(returns(timeSt:timeSt+129,1),'BinEdges',binEdges1);
    empDist1 = empObs1'/sum(empObs1);
    rolDistn((timeSt+129)/130,1) = kl_distance(empDist1,iProj1);
    
    empObs2 = histcounts(returns(timeSt:timeSt+129,2),'BinEdges',binEdges2);
    empDist2 = empObs2'/sum(empObs2);
    rolDistn((timeSt+129)/130,2) = kl_distance(empDist2,iProj2);
    
    empObs3 = histcounts(returns(timeSt:timeSt+129,3),'BinEdges',binEdges3);
    empDist3 = empObs3'/sum(empObs3);
    rolDistn((timeSt+129)/130,3) = kl_distance(empDist3,iProj3);
end

subplot(2,1,1)
plot(dates(130:130:end),rolSumQuant(:,1),'r')
grid minor
hold on
plot(dates(130:130:end),rolSumQuant(:,2),'g')
plot(dates(130:130:end),rolSumQuant(:,3),'b')

subplot(2,1,2)
plot(dates(130:130:end),rolDistn(:,1),'r')
grid minor
hold on
plot(dates(130:130:end),rolDistn(:,2),'g')
plot(dates(130:130:end),rolDistn(:,3),'b')

% yyaxis left
% plot(dates(130:130:end),rolSumQuant)
% grid minor
% yyaxis right
% plot(dates(130:130:end),rolDistn)

function d = kl_distance(p,q)
    % base e logarithm
    nonzeroIndex = (p~=0);
    p = p(nonzeroIndex);
    q = q(nonzeroIndex);
    d = p'*log(p./q);
end

function iProj = i_proj(alphabet,dist,mean)
    % I-project dist to the convex set {mean(dist)<=mean}
    iProj = dist;
    if iProj'*alphabet <= mean
        return
    end

    % since the set is convex and alphabet is finite
    % the projection is the minimum tilt tilted distribution
    % tilt dist iteratively until error is small
    eps = 1e-3;
    err = inf;
    while abs(err)>eps
        iProj = iProj.*exp(sign(err)*eps*alphabet);
        iProj = iProj/sum(iProj);
        err = mean-iProj'*alphabet;
    end

end