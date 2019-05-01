M = xlsread('quelccaya2013.xlsx');
time = M(:,1);
acc = M(1:end-457,3); % last 457 points are NaN

binEdges1 = [-inf; 0.8160; 0.9500; 1.1160; 1.2230; 1.4820; inf];

accReps = zeros(6,1);
for i = 1:6
    accReps(i) = mean(acc((binEdges1(i)<=acc)&(acc<binEdges1(i+1))));
end

[~,quantacc] = quantiz(acc,binEdges1(2:end-1),accReps);

meanThr1 = 1.15;
klThr = 1e1;
movSumQuantacc = movsum(quantacc,36,'Endpoints','discard')/36;
rolSumQuantacc = movSumQuantacc(1:36:end,:);

iProjacc = i_proj(accReps,1/6*ones(6,1),meanThr1);

rolDistn1 = zeros(floor(length(acc)/36),1);
for timeSt = 1:36:length(acc)-36
    empObs1 = histcounts(acc(timeSt:timeSt+35),'BinEdges',binEdges1);
    empDist1 = empObs1'/sum(empObs1);
    rolDistn1((timeSt+35)/36) = kl_distance(empDist1,iProjacc);
end

subplot(2,1,1)
plot(time(1:36:end-457-35),rolSumQuantacc,'r')
grid minor

subplot(2,1,2)
plot(time(1:36:end-457-35),rolDistn1,'r')
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