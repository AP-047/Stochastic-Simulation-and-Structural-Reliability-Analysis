% Task 3 - Part 1: Calculate Random Fields for Frame Elements Divided into Two

% Parameters for the random field (E-modulus)
mu_X = 210e9; % Mean E-modulus in Pascals (210 GPa)
sigma_X = 15e9; % Standard deviation in Pascals (15 GPa)
theta = 6; % Correlation length (used for spatial correlation)

% Number of original elements (each will be divided into two)
num_elements = 3; % Three elements in the original structure
num_sub_elements = 2; % Each element is divided into two sub-elements

% Cross-sectional areas and moments of inertia (from the original code)
A1 = 2e-3; % Cross-sectional area for element 1 and 2
A2 = 6e-3; % Cross-sectional area for element 3
I1 = 1.6e-5; % Moment of inertia for element 1 and 2
I2 = 5.4e-5; % Moment of inertia for element 3

% Topology matrix Edof (from exs_beam2)
Edof = [1 4 5 6 1 2 3;
        2 7 8 9 10 11 12;
        3 4 5 6 7 8 9];  

% Initialize stiffness matrix K and load vector f
K = zeros(12); % 12 DOFs in total for the system
f = zeros(12,1); % Load vector
f(4) = 2e+3; % Apply load at node 4 (as in the original code)

% Generate random fields for each sub-element's E-modulus
E_random = zeros(num_elements * num_sub_elements, 1);

for i = 1:num_elements
    % Generate E-modulus for the first sub-element
    E1 = normrnd(mu_X, sigma_X);

    % Generate E-modulus for the second sub-element, correlated with the first
    rho = exp(-1/theta); % Correlation coefficient based on theta
    E2 = E1 + rho * normrnd(0, sigma_X); % Correlated value for second sub-element

    % Store the values for both sub-elements
    E_random((i-1)*2 + 1) = E1;
    E_random((i-1)*2 + 2) = E2;
end

% Display the random E-modulus values for the sub-elements
fprintf('Random E-modulus values (GPa) for the frame elements divided into two:\n');
for i = 1:length(E_random)
    fprintf('Element %d: E = %.2f GPa\n', i, E_random(i) / 1e9);
end

% Element properties for the sub-elements (using random E-modulus values)
% Element 1 divided into two sub-elements
ep1_1 = [E_random(1), A1, I1]; % First sub-element of element 1
ep1_2 = [E_random(2), A1, I1]; % Second sub-element of element 1

% Element 2 divided into two sub-elements
ep2_1 = [E_random(3), A1, I1]; % First sub-element of element 2
ep2_2 = [E_random(4), A1, I1]; % Second sub-element of element 2

% Element 3 divided into two sub-elements
ep3_1 = [E_random(5), A2, I2]; % First sub-element of element 3
ep3_2 = [E_random(6), A2, I2]; % Second sub-element of element 3

% Element coordinates (before division)
ex1 = [0 0]; ey1 = [4 0]; % Element 1 coordinates
ex2 = [6 6]; ey2 = [4 0]; % Element 2 coordinates
ex3 = [0 6]; ey3 = [4 4]; % Element 3 coordinates

% Now divide the elements into two sub-elements:
% Sub-element 1
ex1_1 = [0 0]; ey1_1 = [4 2]; % First sub-element of element 1
ex1_2 = [0 0]; ey1_2 = [2 0]; % Second sub-element of element 1

ex2_1 = [6 6]; ey2_1 = [4 2]; % First sub-element of element 2
ex2_2 = [6 6]; ey2_2 = [2 0]; % Second sub-element of element 2

ex3_1 = [0 3]; ey3_1 = [4 4]; % First sub-element of element 3
ex3_2 = [3 6]; ey3_2 = [4 4]; % Second sub-element of element 3

% Calculate the stiffness matrices for the sub-elements
Ke1_1 = beam2e(ex1_1, ey1_1, ep1_1);
Ke1_2 = beam2e(ex1_2, ey1_2, ep1_2);
Ke2_1 = beam2e(ex2_1, ey2_1, ep2_1);
Ke2_2 = beam2e(ex2_2, ey2_2, ep2_2);
Ke3_1 = beam2e(ex3_1, ey3_1, ep3_1);
Ke3_2 = beam2e(ex3_2, ey3_2, ep3_2);

% Assembly of sub-elements into global stiffness matrix (using Edof)
K = assem(Edof(1,:), K, Ke1_1);
K = assem(Edof(1,:), K, Ke1_2);
K = assem(Edof(2,:), K, Ke2_1);
K = assem(Edof(2,:), K, Ke2_2);
K = assem(Edof(3,:), K, Ke3_1);
K = assem(Edof(3,:), K, Ke3_2);

% Boundary conditions
bc = [1 0; 2 0; 3 0; 10 0; 11 0]; % Fixed boundary conditions

% Solve the system of equations
[a, r] = solveq(K, f, bc);

% Display the displacements and reactions
fprintf('Displacements at nodes:\n');
disp(a);

fprintf('Reactions at constrained nodes:\n');
disp(r);