M = xlsread('industry-portfolios-value-weighted-daily.xls');
oil = M(:,22);
dates = M(:,1)+(M(:,2)-1)/12;

binEdges = [-inf; -1.27; -0.71; -0.39; -0.16; 0.05; 0.25; 0.49; 0.8; ...
    1.36; inf];
reps = zeros(10,1);
for i = 1:10
    reps(i) = mean(oil((binEdges(i)<=oil)&(oil<binEdges(i+1))));
end

[~,quantOil] = quantiz(oil,binEdges(2:end-1),reps);
meanThr = -0.16;
klThr = 1e1;
movSumQuant = movsum(quantOil,130,'Endpoints','discard')/130;
rolSumQuant = movSumQuant(1:130:end);
iProj = i_proj(reps,1/10*ones(10,1),meanThr);
rolDistn = zeros(floor(length(oil)/130),1);
for timeSt = 1:130:length(oil)-130
    empObs = histcounts(oil(timeSt:timeSt+129),'BinEdges',binEdges);
    empDist = empObs'/sum(empObs);
    rolDistn((timeSt+129)/130) = kl_distance(empDist,iProj);
end

subplot(2,1,1)
plot(dates(130:130:end),rolSumQuant)
grid minor
hold on
subplot(2,1,2)
plot(dates(130:130:end),rolDistn)
grid minor

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