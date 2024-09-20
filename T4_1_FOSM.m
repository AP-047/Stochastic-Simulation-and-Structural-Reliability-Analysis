% First Order Second Moment (FOSM) Method

% Mean and standard deviation of random variables
mu_X1_g1 = 12; sigma_X1_g1 = 5;  % X1 for g1
mu_X2_g1 = 10; sigma_X2_g1 = 9;  % X2 for g1

mu_X1_g2 = 10; sigma_X1_g2 = 3;  % X1 for g2
mu_X2_g2 = 1;  sigma_X2_g2 = 1;  % X2 for g2 (Exponential dist has rate 1)

% Mean of the limit state functions
mu_g1 = 3 * mu_X1_g1 - 2 * mu_X2_g1 + 18;  % Mean of g1
mu_g2 = mu_X1_g2^2 - mu_X2_g2^3 + 23;     % Mean of g2

% Partial derivatives (sensitivities) for g1 and g2
dg1_dX1 = 3;  % dg1/dX1 = 3
dg1_dX2 = -2; % dg1/dX2 = -2

dg2_dX1 = 2 * mu_X1_g2;    % dg2/dX1 = 2 * X1
dg2_dX2 = -3 * mu_X2_g2^2; % dg2/dX2 = -3 * X2^2

% Standard deviation of the limit state functions
sigma_g1 = sqrt((dg1_dX1 * sigma_X1_g1)^2 + (dg1_dX2 * sigma_X2_g1)^2);  % Standard deviation of g1
sigma_g2 = sqrt((dg2_dX1 * sigma_X1_g2)^2 + (dg2_dX2 * sigma_X2_g2)^2);  % Standard deviation of g2

% Reliability index (beta) for g1 and g2
beta_g1_FOSM = mu_g1 / sigma_g1;
beta_g2_FOSM = mu_g2 / sigma_g2;

% Probability of failure for g1 and g2 using FOSM
pf_g1_FOSM = normcdf(-beta_g1_FOSM);
pf_g2_FOSM = normcdf(-beta_g2_FOSM);

% Display results
disp(['FOSM - Reliability index (beta) for g1: ', num2str(beta_g1_FOSM)]);
disp(['FOSM - Probability of failure for g1: ', num2str(pf_g1_FOSM)]);

disp(['FOSM - Reliability index (beta) for g2: ', num2str(beta_g2_FOSM)]);
disp(['FOSM - Probability of failure for g2: ', num2str(pf_g2_FOSM)]);