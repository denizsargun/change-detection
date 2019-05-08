years = M(:,1);
d18O = M(:,2);
iceAcc = M(1:end-457,3);
d18OS = sort(d18O);
iceAccS = sort(iceAcc);
binEdges1 = [-inf; d18OS(round(length(d18OS)*0.25)); ...
    d18OS(round(length(d18OS)*0.5)); d18OS(round(length(d18OS)*0.75)); inf];
binEdges2 = [-inf; iceAccS(round(length(iceAccS)*0.25)); ...
    iceAccS(round(length(iceAccS)*0.5)); ...
    iceAccS(round(length(iceAccS)*0.75)); inf];
d18OReps = zeros(4,1);
iceAccReps = zeros(4,1);
for i = 1:4
    d18OReps(i) = mean(d18O((binEdges1(i)<=d18O)&(d18O<binEdges1(i+1))));
    iceAccReps(i) = mean(iceAcc((binEdges2(i)<=iceAcc)&(iceAcc<binEdges2(i+1))));
end

quantd18O = zeros(length(d18O),1);
quantIceAcc = zeros(length(iceAcc),1);
for i = 1:length(quantd18O)
    for j = 1:4
        if (d18O(i)>binEdges1(j)) && (d18O(i)<=binEdges1(j+1))
            quantd18O(i) = d18OReps(j);
        end
        
    end
    
end

for i = 1:length(quantIceAcc)
    for j = 1:4
        if (iceAcc(i)>binEdges1(j)) && (iceAcc(i)<=binEdges1(j+1))
            quantIceAcc(i) = iceAccReps(j);
        end
        
    end
    
end

meanThr1 = mean(quantd18O)+0.15*std(quantd18O);
meanThr2 = mean(quantIceAcc)+0.1*std(quantIceAcc);
movSumQuantd18O = movsum(quantd18O,20,'Endpoints','discard')/20;
rolSumQuantd18O = movSumQuantd18O(1:20:end,:);
movSumQuantIceAcc = movsum(quantIceAcc,20,'Endpoints','discard')/20;
rolSumQuantIceAcc = movSumQuantIceAcc(1:20:end,:);

iProjd18O = i_proj(d18OReps,1/4*ones(4,1),meanThr1);
iProjIceAcc = i_proj(iceAccReps,1/4*ones(4,1),meanThr2);

rolDistn1 = zeros(floor(length(d18O)/20),1);
rolDistn2 = zeros(floor(length(iceAcc)/20),1);
for timeSt = 1:20:length(d18O)-20
    empObs1 = histcounts(d18O(timeSt:timeSt+19),'BinEdges',binEdges1);
    empDist1 = empObs1'/sum(empObs1);
    rolDistn1((timeSt+19)/20) = kl_distance(empDist1,iProjd18O);
end

for timeSt = 1:20:length(iceAcc)-20
    empObs2 = histcounts(iceAcc(timeSt:timeSt+19),'BinEdges',binEdges2);
    empDist2 = empObs2'/sum(empObs2);
    rolDistn2((timeSt+19)/20) = kl_distance(empDist2,iProjIceAcc);
end

% subplot(2,1,1)
% yyaxis left
% plot(years(1:20:end-19),rolSumQuantd18O,'b')
% grid minor
% yyaxis right
% plot(years(1:20:end-19-457),rolSumQuantIceAcc,'r')

subplot(2,1,1)
plot(years(1:20:end-19),rolSumQuantd18O,'r')
grid minor

% left_color = [1 0 0];
% right_color = [0 0 1];
% set(fig,'defaultAxesColorOrder',[left_color; right_color]);

% subplot(2,1,2)
% yyaxis left
% plot(years(1:20:end-19),rolDistn1,'b')
% grid minor
% yyaxis right
% plot(years(1:20:end-19-457),rolDistn2,'r')

subplot(2,1,2)
plot(years(1:20:end-19),rolDistn1,'r')
grid minor

% left_color = [1 0 0];
% right_color = [0 0 1];
% set(fig,'defaultAxesColorOrder',[left_color; right_color]);

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