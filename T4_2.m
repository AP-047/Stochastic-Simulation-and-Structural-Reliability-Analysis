% Monte Carlo Simulation Parameters
N = 10000; % Number of simulations

% Parameters for g1: X1 ~ N(12, 5) and X2 ~ N(10, 9)
mu_X1_g1 = 12;
sigma_X1_g1 = 5;
mu_X2_g1 = 10;
sigma_X2_g1 = 9;

% Parameters for g2: X1 ~ N(10, 3) and X2 ~ Exp(1)
mu_X1_g2 = 10;
sigma_X1_g2 = 3;
lambda_X2_g2 = 1; % X2 follows Exp(1), lambda = 1

% Simulate random variables for g1
X1_g1 = normrnd(mu_X1_g1, sigma_X1_g1, N, 1);
X2_g1 = normrnd(mu_X2_g1, sigma_X2_g1, N, 1);

% Simulate random variables for g2
X1_g2 = normrnd(mu_X1_g2, sigma_X1_g2, N, 1);
X2_g2 = exprnd(1/lambda_X2_g2, N, 1); % Exponential distribution

% Limit state functions
g1 = 3 * X1_g1 - 2 * X2_g1 + 18;
g2 = X1_g2.^2 - X2_g2.^3 + 23;

% Define safe and failure regions for g1 and g2
safe_g1 = g1 >= 0;
failure_g1 = g1 < 0;

safe_g2 = g2 >= 0;
failure_g2 = g2 < 0;

% Plotting in X-space (Original Space) for g1
figure;
scatter(X1_g1(safe_g1), X2_g1(safe_g1), 10, 'g', 'filled'); hold on;
scatter(X1_g1(failure_g1), X2_g1(failure_g1), 10, 'r', 'filled');
xlabel('X1 (g1)');
ylabel('X2 (g1)');
title('X-space: Safe/Failure Region for g1');
legend('Safe', 'Failure');
grid on;

% Plotting in X-space (Original Space) for g2
figure;
scatter(X1_g2(safe_g2), X2_g2(safe_g2), 10, 'g', 'filled'); hold on;
scatter(X1_g2(failure_g2), X2_g2(failure_g2), 10, 'r', 'filled');
xlabel('X1 (g2)');
ylabel('X2 (g2)');
title('X-space: Safe/Failure Region for g2');
legend('Safe', 'Failure');
grid on;

% Standardize X1 and X2 (U-space transformation)
U1_g1 = (X1_g1 - mu_X1_g1) / sigma_X1_g1;
U2_g1 = (X2_g1 - mu_X2_g1) / sigma_X2_g1;

U1_g2 = (X1_g2 - mu_X1_g2) / sigma_X1_g2;
U2_g2 = -log(X2_g2); % Exponential to normal space

% Plotting in U-space (Transformed Standard Normal Space) for g1
figure;
scatter(U1_g1(safe_g1), U2_g1(safe_g1), 10, 'g', 'filled'); hold on;
scatter(U1_g1(failure_g1), U2_g1(failure_g1), 10, 'r', 'filled');
xlabel('U1 (g1)');
ylabel('U2 (g1)');
title('U-space: Safe/Failure Region for g1');
legend('Safe', 'Failure');
grid on;

% Plotting in U-space (Transformed Standard Normal Space) for g2
figure;
scatter(U1_g2(safe_g2), U2_g2(safe_g2), 10, 'g', 'filled'); hold on;
scatter(U1_g2(failure_g2), U2_g2(failure_g2), 10, 'r', 'filled');
xlabel('U1 (g2)');
ylabel('U2 (g2)');
title('U-space: Safe/Failure Region for g2');
legend('Safe', 'Failure');
grid on;