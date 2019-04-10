function plot_loglog_convex(x,y,opt)
    % plot convexification of plot(x,y,opt)
    % not computationally efficient :)
    edgeIndeces = ones(1,length(x));
    for i = 1:length(x)
        for j = i+1:length(x)
            if x(i) >= x(j) && y(i) > y(j)
                edgeIndeces(i) = 0;
            elseif x(j) >= x(i) && y(j) > y(i)
                edgeIndeces(j) = 0;
            end
            
        end
        
    end
    
    for i = find(edgeIndeces)
        for j = find(edgeIndeces)
            for k = find(edgeIndeces)
                if x(k) < x(i) && x(k) > x(j)
                    if (x(k)-x(j))*(y(i)-y(k))-(y(k)-y(j))*(x(i)-x(k)) < 0
%                         [i x(i) y(i)]
%                         [j x(j) y(j)]
%                         [k x(k) y(k)]
%                         (x(k)-x(j))*y(i)+(x(i)-x(k))*y(j)+(x(j)-x(i))*y(k)
%                         find(edgeIndeces)
                        edgeIndeces(k) = 0;
                    end
                    
                end
                
            end
            
        end
        
    end
    
    dum = [x(find(edgeIndeces))' y(find(edgeIndeces))'];
    dum = sortrows(dum);
    loglog(dum(:,1),dum(:,2),opt)
end