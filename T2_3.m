% Task 2 - Part 3: Smarter Approach with Sigma Values starting from 2.8 GPa

% Initial parameters
target_beta = 3.0; % Desired reliability index
num_simulations = 3000; % Number of Monte Carlo simulations
mu_E = 200e9; % Mean Young's Modulus in Pascals (200 GPa)

f = zeros(8,1); f(6) = -80e3; % Load
bc = [1 0; 2 0; 3 0; 4 0; 7 0; 8 0]; % Boundary conditions (fixed supports)

ex1 = [0 1.6]; ey1 = [0 0]; % Coordinates for element 1
ex2 = [1.6 1.6]; ey2 = [0 1.2]; % Coordinates for element 2
ex3 = [0 1.6]; ey3 = [1.2 0]; % Coordinates for element 3
A1 = 6.0e-4; A2 = 3.0e-4; A3 = 10.0e-4; % Cross-sectional areas of the bars

% Define the topology matrix Edof
Edof = [1 1 2 5 6; 
        2 5 6 7 8; 
        3 3 4 5 6];

% Key standard deviations to check starting from 2.8 GPa
sigma_values = [2.8e9, 3.0e9, 3.2e9, 3.4e9, 3.6e9, 3.8e9, 4.0e9];

% Store results for plotting and interpolation
sigma_results = [];
beta_results = [];

for sigma_E = sigma_values
    failures = 0; % Reset failure counter for each iteration

    for i = 1:num_simulations
        % Generate random Young's modulus for each bar with current sigma_E
        E_random = normrnd(mu_E, sigma_E, [1, 3]);

        % Assign element properties with random Young's modulus
        ep1 = [E_random(1) A1];
        ep2 = [E_random(2) A2];
        ep3 = [E_random(3) A3];

        % Stiffness matrix K
        K = zeros(8,8);
        Ke1 = bar2e(ex1, ey1, ep1); 
        Ke2 = bar2e(ex2, ey2, ep2);
        Ke3 = bar2e(ex3, ey3, ep3);
        K = assem(Edof(1,:), K, Ke1);
        K = assem(Edof(2,:), K, Ke2); 
        K = assem(Edof(3,:), K, Ke3);

        % Solve for displacements
        [a, ~] = solveq(K, f, bc);

        % Record vertical displacement at node 6 (corresponding to f(6) load)
        vertical_displacement = abs(a(6));

        % Check if the displacement exceeds 1.2 mm
        if vertical_displacement > 1.2e-3
            failures = failures + 1;
        end
    end

    % Calculate the probability of failure
    probability_of_failure = failures / num_simulations;

    % Reliability Index calculation
    if probability_of_failure == 0
        current_beta = Inf; % Avoid division by zero
    else
        current_beta = -norminv(probability_of_failure);
    end

    % Store the results for later interpolation
    sigma_results = [sigma_results, sigma_E];
    beta_results = [beta_results, current_beta];

    % Display the current results
    fprintf('Sigma: %.2f GPa, Probability of failure: %.4f, Reliability index: %.4f\n', ...
        sigma_E / 1e9, probability_of_failure, current_beta);
end

% Remove infinite values before interpolation
finite_indices = isfinite(beta_results);
sigma_finite = sigma_results(finite_indices);
beta_finite = beta_results(finite_indices);

% Remove duplicates to make sure beta values are unique
[beta_finite, unique_idx] = unique(beta_finite);
sigma_finite = sigma_finite(unique_idx);

% Plot the results for interpolation
figure;
plot(sigma_finite / 1e9, beta_finite, '-o');
xlabel('Sigma (GPa)');
ylabel('Reliability Index (Beta)');
title('Reliability Index vs. Sigma');
grid on;

% Interpolate to find sigma for Beta = 3.0
sigma_interp = interp1(beta_finite, sigma_finite, 3.0, 'linear');
fprintf('Interpolated sigma for reliability index = 3.0: %.2f GPa\n', sigma_interp / 1e9);