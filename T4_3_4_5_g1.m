% FORM - Hasofer-Lind Rackwitz- Fiessler Iteration
% According to example of C. Bucher, 
% Stochastic Simulation Methods and Structural Reliability, 
% 2015, T. Lahmer
% Code mofified for the problem

function [pf, beta] = ExampleClass_quadratic_FORM_g1

% Statistical properties of first random variable (X1)
m1 = 12; % Mean
s1 = 5;  % Standard deviation

% Statistical properties of second random variable (X2)
m2 = 10; % Mean
s2 = 9;  % Standard deviation

% Initialize the vector u (standard normal space)
u0 = [0; 0];  % Basic initial guess
u = u0;
uall = u';

tol = 1e-7;  % Tighter convergence tolerance
max_iter = 100;  % Maximum number of iterations
damping_factor = 0.02;  % Small damping factor for stability

% Iterate to find the Most Probable Point (MPP)
for i = 1:max_iter
    g = grad_g1(u, s1, s2, m1, m2);  % Gradient of g1
    gtg = g' * g;
    gtu = g' * u;
    f = limitState_g1(u, s1, s2, m1, m2);  % Limit-state function for g1
    lambda_update = damping_factor * (f - gtu) / gtg;
    v = g * (-lambda_update) - u;
    
    % Update u and check convergence
    u_new = u + v;
    uall = [uall; u_new'];
    
    % Print intermediate u and beta for observation
    fprintf('Iteration %d: u = [%f, %f], beta = %f\n', i, u_new(1), u_new(2), sqrt(u_new' * u_new));

    if norm(u_new - u) < tol
        break;
    end
    u = u_new;
    
    % Update beta (Safety index)
    beta = sqrt(u' * u);
end

% Print results for 4.3
fprintf('\nSafety Index beta = %f ', beta);
fprintf('\nProbability of failure pf = %f \n', normcdf(-beta));

% Calculate probability of failure
pf = normcdf(-beta);

% Backtransformation into original space
x1s = s1 * u(1) + m1;  % X1 in original space
x2s = s2 * u(2) + m2;  % X2 in original space

% Print MPFP
fprintf('\nMPFP in U-space: u* = [%f, %f]\n', u(1), u(2));
fprintf('MPFP in X-space: X* = [%f, %f]\n', x1s, x2s);

% --- Plot 1: Limit State Function in U-space with Separation (for 4.4 and 4.5) ---

figure;

% Create a grid of points in U-space
[u1_grid, u2_grid] = meshgrid(linspace(-3, 3, 100), linspace(-3, 3, 100));

% Compute the limit state function g1 over the grid
g_values = zeros(size(u1_grid));
for i = 1:size(u1_grid, 1)
    for j = 1:size(u1_grid, 2)
        g_values(i, j) = limitState_g1([u1_grid(i, j); u2_grid(i, j)], s1, s2, m1, m2);
    end
end

% Plot the limit state boundary (g = 0) and fill below/above the limit state
contourf(u1_grid, u2_grid, g_values, [-100 0], 'LineColor', 'none'); % Failure region (red)
hold on;
contour(u1_grid, u2_grid, g_values, [0 0], 'LineColor', 'black', 'LineWidth', 1.5); % Limit state boundary (g = 0)
colormap([1 0.8 0.8; 0.8 1 0.8]); % Red for failure region, green for safe region
colorbar;
hold on;

% Plot the iteration path, MPFP, and Pf point
h1 = plot(uall(:,1), uall(:,2), 'b-', 'LineWidth', 1.5); % Path to MPP in U-space
h2 = scatter(u(1), u(2), 50, 'filled', 'r'); % MPFP in U-space
h3 = scatter(1, pf, 50, 'filled', 'g'); % Pf as a green point in U-space

% Add labels and title
xlabel('U1');
ylabel('U2');
title('Limit State Function g1 in U-space with P_f');

% Add legend
legend([h2, h3], {'MPFP (Most Probable Failure Point)', 'Pf Point'}, 'Location', 'best');

grid on;

% --- Plot MPFP in X-space (for 4.5) ---
figure;
scatter(x1s, x2s, 50, 'filled', 'r');
xlabel('X_1');
ylabel('X_2');
title('MPFP in X-space for g_1');
grid on;

end

% Gradient of limit-state function g1
function grad_g1 = grad_g1(u, s1, s2, m1, m2)
    x1 = s1 * u(1) + m1;
    x2 = s2 * u(2) + m2;
    grad_g1 = [3; -2];  % Derivatives of g1
end

% Limit-state function g1 = 3*X1 - 2*X2 + 18
function ls_g1 = limitState_g1(u, s1, s2, m1, m2)
    x1 = s1 * u(1) + m1;
    x2 = s2 * u(2) + m2;
    ls_g1 = 3 * x1 - 2 * x2 + 18;  % Limit-state function g1
end