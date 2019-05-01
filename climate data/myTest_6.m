M = xlsread('quelccaya2013.xlsx');
years = M(:,1);
d18O = M(:,2);
iceAcc = M(1:end-457,3); % after  1328 iceAcc is NaN

binEdges1 = [-inf; -19.5300; -18.8200; -18.4200; -18.1300; -17.8800; -17.5800; -17.3300; -17; -16.4700; inf];
binEdges2 = [-inf; 0.7750; 0.8350; 0.9230; 0.9950; 1.1160; 1.1860; 1.2580; 1.4310; 1.6440; inf];

d18OReps = zeros(10,1);
iceAccReps = zeros(10,1);
for i = 1:10
    d18OReps(i) = mean(d18O((binEdges1(i)<=d18O)&(d18O<binEdges1(i+1))));
    iceAccReps(i) = mean(iceAcc((binEdges2(i)<=iceAcc)&(iceAcc<binEdges2(i+1))));
end

[~,quantd18O] = quantiz(d18O,binEdges1(2:end-1),d18OReps);
[~,quantIceAcc] = quantiz(iceAcc,binEdges2(2:end-1),iceAccReps);

meanThr1 = mean(quantd18O)+0.2*std(quantd18O);
meanThr2 = mean(quantIceAcc)+0.2*std(quantIceAcc);
movSumQuantd18O = movsum(quantd18O,75,'Endpoints','discard')/75;
movSumQuantIceAcc = movsum(quantIceAcc,75,'Endpoints','discard')/75;

iProjd18O = i_proj(d18OReps,1/10*ones(10,1),meanThr1);
iProjIceAcc = i_proj(iceAccReps,1/10*ones(10,1),meanThr2);

movDistn1 = zeros(length(movSumQuantd18O),1);
movDistn2 = zeros(length(movSumQuantIceAcc),1);
for timeSt = 1:length(d18O)-74
    empObs1 = histcounts(d18O(timeSt:timeSt+74),'BinEdges',binEdges1);
    empDist1 = empObs1'/sum(empObs1);
    movDistn1(timeSt) = kl_distance(empDist1,iProjd18O);
end

for timeSt = 1:length(iceAcc)-74
    empObs2 = histcounts(iceAcc(timeSt:timeSt+74),'BinEdges',binEdges2);
    empDist2 = empObs2'/sum(empObs2);
    movDistn2(timeSt) = kl_distance(empDist2,iProjIceAcc);
end

subplot(2,1,1)
yyaxis left
plot(years(1:end-74),movSumQuantd18O,'r')
grid minor
yyaxis right
plot(years(1:end-74-457),movSumQuantIceAcc,'b')

subplot(2,1,2)
yyaxis left
plot(years(1:end-74),movDistn1,'r')
grid minor
yyaxis right
plot(years(1:end-74-457),movDistn2,'b')

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
    if iProj'*alphabet >= mean
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