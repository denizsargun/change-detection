function plot_convex(x,y,opt)
    ind = convhull(x,y);
    [~, in] = max(x(ind));
    plot(x(ind(1:in)),y(ind(1:in)),opt)
end