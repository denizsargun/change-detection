M = xlsread('quelccaya2013.xlsx');
years = M(:,1);
dust = M(8:end,4);

binEdges1 = [-inf; 13253; 15633; 17772; 19730; 21750; 23880; 26400; 29305; 35560; inf];

dustReps = zeros(10,1);
for i = 1:10
    dustReps(i) = mean(dust((binEdges1(i)<=dust)&(dust<binEdges1(i+1))));
end

[~,quantdust] = quantiz(dust,binEdges1(2:end-1),dustReps);

meanThr1 = 3.5e4;
klThr = 1e1;
movSumQuantdust = movsum(quantdust,75,'Endpoints','discard')/75;
rolSumQuantdust = movSumQuantdust(1:75:end,:);

iProjdust = i_proj(dustReps,1/10*ones(10,1),meanThr1);

rolDistn1 = zeros(floor(length(dust)/75),1);
for timeSt = 1:75:length(dust)-75
    empObs1 = histcounts(dust(timeSt:timeSt+74),'BinEdges',binEdges1);
    empDist1 = empObs1'/sum(empObs1);
    rolDistn1((timeSt+74)/75) = kl_distance(empDist1,iProjdust);
end

subplot(2,1,1)
plot(years(1:75:end-74),rolSumQuantdust-mean(rolSumQuantdust),'r')

subplot(2,1,2)
plot(years(1:75:end-74),rolDistn1,'r')

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
    eps = 1e-5;
    err = inf;
    while abs(err)>eps*(max(alphabet)-min(alphabet))
        iProj = iProj.*exp(sign(err)*eps*alphabet);
        iProj = iProj/sum(iProj);
        err = mean-iProj'*alphabet;
    end

end