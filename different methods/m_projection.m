% given alphabet (size m), M-project distribution p on to
% the set of distributions with mean >= beta using KKT conditions
% for the convex problem q^*=argmin_{Eq >= beta} D(p||q)

% example inputs
alphabet = -2:2';
beta = .5;
p = [.3 .2 .1 .25 .15]';

% start dual
lambda = rand(m+1,1); % Lagrangian multipliers corresponding to p >= 0 and mean constraint
nu = rand; % Lagrangian multiplier corresponding to sum(p) = 1
q = zeros(m,1);
% solve for p, lambda and nu in terms of lambda(m+1) and nu and satisfy
% normalization and mean
if alphabet'*p >= beta
    q = p;
else %alphabet'*p=beta
    supportP = find(p>0);
    nonsupportP = find(p==0);
    error = inf;
    while error >= tolerance
        gradNu = 2*(sum(q./(nu-alphabet*lambda(m+1)))-1)*sum(-q./(nu-alphabet*lambda(m+1)).^2)+2*(sum(alphabet.*q./(nu-alphabet*lambda(m+1)))-beta)*sum(-alphabet.*q./(nu-alphabet*lambda(m+1)).^2);
        gradLambdaEnd = 2*(sum(q./(nu-alphabet*lambda(m+1)))-1)*sum(alphabet.*q./(nu-alphabet*lambda(m+1)).^2)+2*(sum(alphabet.*q./(nu-alphabet*lambda(m+1)))-beta)*sum(alphabet.^2.*q./(nu-alphabet*lambda(m+1)).^2);
        nu = nu+learningRate*gradNu;
        lambda(m+1) = lambda(m+1)+learningRate*gradLambdaEnd;
        q(supportP) = p(supportP)./(nu-alphabet(supportP)*lambda(m+1));
        error = (sum(q)-1)^2+(alphabet'*q-beta)^2;
    end
    
end