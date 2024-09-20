% Task 2 - Part 2: Monte Carlo Simulation for Displacement Exceeding 1.2 mm

% Parameters
num_simulations = 1000; % Number of Monte Carlo simulations
mu_E = 200e9; % Mean Young's Modulus in Pascals (200 GPa)
sigma_E = 10e9; % Standard deviation in Pascals (10 GPa)

f = zeros(8,1); f(6) = -80e3; % Load
bc = [1 0; 2 0; 3 0; 4 0; 7 0; 8 0]; % Boundary conditions (fixed supports)

ex1 = [0 1.6]; ey1 = [0 0]; % Coordinates for element 1
ex2 = [1.6 1.6]; ey2 = [0 1.2]; % Coordinates for element 2
ex3 = [0 1.6]; ey3 = [1.2 0]; % Coordinates for element 3
A1 = 6.0e-4; A2 = 3.0e-4; A3 = 10.0e-4; % Cross-sectional areas of the bars

% Define the topology matrix Edof
Edof = [1 1 2 5 6; % Element 1 connects nodes 1 and 2 to 5 and 6
        2 5 6 7 8; % Element 2 connects nodes 5 and 6 to 7 and 8
        3 3 4 5 6]; % Element 3 connects nodes 3 and 4 to 5 and 6

failures = 0; % Initialize failure counter
displacements = zeros(num_simulations, 1); % Store displacements

for i = 1:num_simulations
    % Generate random Young's modulus for each bar
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
    displacements(i) = vertical_displacement;

    % Check if the displacement exceeds 1.2 mm
    if vertical_displacement > 1.2e-3
        failures = failures + 1;
    end
end

% Calculate the probability of failure
probability_of_failure = failures / num_simulations;

% Reliability Index calculation
reliability_index = -norminv(probability_of_failure);

% Display results
fprintf('Probability of failure: %.4f\n', probability_of_failure);
fprintf('Reliability index: %.4f\n', reliability_index);