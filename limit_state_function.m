function g = limit_state_function(X)
    P = X(:,1);
    L = X(:,2);
    W = X(:,3);
    T = X(:,4);
    g = W .* T - (P .* L) ./ 4;
end
