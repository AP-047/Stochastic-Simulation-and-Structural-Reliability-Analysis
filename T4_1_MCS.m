% Monte Carlo Simulation for g1 and g2

% Number of Monte Carlo simulations
N = 20000;

% Pre-allocate arrays to store limit state function values
g1_values = zeros(N, 1);
g2_values = zeros(N, 1);

% Generate random samples for X1 and X2 for g1
X1_g1 = normrnd(12, 5, [N, 1]); % X1 ~ N(12, 5)
X2_g1 = normrnd(10, 9, [N, 1]); % X2 ~ N(10, 9)

% Generate random samples for X1 and X2 for g2
X1_g2 = normrnd(10, 3, [N, 1]); % X1 ~ N(10, 3)
X2_g2 = exprnd(1, [N, 1]);      % X2 ~ Exp(1)

% Evaluate the limit state functions g1 and g2
g1_values = 3 * X1_g1 - 2 * X2_g1 + 18;
g2_values = X1_g2.^2 - X2_g2.^3 + 23;

% Calculate probability of failure for g1 (failures where g1 <= 0)
failures_g1 = sum(g1_values <= 0);
pf_g1 = failures_g1 / N;

% Calculate probability of failure for g2 (failures where g2 <= 0)
failures_g2 = sum(g2_values <= 0);
pf_g2 = failures_g2 / N;

% Calculate reliability index (beta) for g1 and g2
beta_g1 = -norminv(pf_g1);
beta_g2 = -norminv(pf_g2);

% Display the results
disp(['Probability of failure for g1: ', num2str(pf_g1)]);
disp(['Reliability index (beta) for g1: ', num2str(beta_g1)]);

disp(['Probability of failure for g2: ', num2str(pf_g2)]);
disp(['Reliability index (beta) for g2: ', num2str(beta_g2)]);