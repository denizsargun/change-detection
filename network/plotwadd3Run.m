worst = zeros(10,1);
changePoints = kron(10.^[0;1;2],[1;3]);
for i = 1:10
    for j = 1:6
        stopMat = squeeze(outputArg(i,j,:,:));
        d = max(max(stopMat))-changePoints(j)+1
        worst(i) = max(worst(i),d);
    end
    
end