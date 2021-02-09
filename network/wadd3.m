pre = prechange();
waddTestData = struct;
waddTestData.readMe = "samples from changed random process. 6 change points, 50 post-change distributions, 50 pre-change realizations, 50 post-change realizations";
waddTestData.changePoints = kron(10.^[0;1;2],[1;3]);
horizon = 10^3;
waddTestData.data = zeros(6,50,50,50,horizon);
for i = 1:6
    cp = waddTestData.changePoints(i);
    for j = 1:50
        post = postchange;
        for k = 1:50
            preSamps = pre.sample(cp-1);
            for l = 1:50
                postSamps = post.sample(horizon-cp+1);
                samps = [preSamps; postSamps];
                waddTestData.data(i,j,k,l,:) = samps;
                [i,j,k,l]
                ((i-1)*50*50*50+(j-1)*50*50+(k-1)*50+l)/(50*50*50*6)
            end
            
        end
        
    end
    
end