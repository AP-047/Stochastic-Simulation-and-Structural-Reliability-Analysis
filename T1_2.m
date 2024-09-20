% Random Field Parameters
mu_X = 30.0; % Mean value of material properties (W/K)
sigma_X = 3.0; % Standard deviation (W/K)
theta = 1.5; % Correlation length
% Generate random field (normally distributed values for material properties)
random_field = normrnd(mu_X, sigma_X, [1, 5]); % 5 sections

% Assign the generated random field to element properties
ep1 = random_field(1);
ep2 = random_field(2);
ep3 = random_field(3);
ep4 = random_field(4);
ep5 = random_field(5);

% Reuse of the rest of the original code
%----- Topology matrix Edof -------------------------------------
Edof = [1 1 2;
        2 2 3;
        3 3 4;
        4 4 5;
        5 5 6];

%----- Stiffness matrix K and load vector f ---------------------
K = zeros(6); 
f = zeros(6,1); f(4) = 10;

%----- Element stiffness matrices (based on random properties) ------------------------------
Ke1 = spring1e(ep1); Ke2 = spring1e(ep2);
Ke3 = spring1e(ep3); Ke4 = spring1e(ep4);
Ke5 = spring1e(ep5);

%----- Assemble Ke into K ---------------------------------------
K = assem(Edof(1,:), K, Ke1); K = assem(Edof(2,:), K, Ke2); 
K = assem(Edof(3,:), K, Ke3); K = assem(Edof(4,:), K, Ke4);
K = assem(Edof(5,:), K, Ke5);

%----- Solve the system of equations ----------------------------
bc = [1 -25; 6 24]; % Boundary conditions: outdoor -25°C, indoor 24°C
[a, r] = solveq(K, f, bc);

%----- Element flows --------------------------------------------
ed1 = extract_ed(Edof(1,:), a);
ed2 = extract_ed(Edof(2,:), a);
ed3 = extract_ed(Edof(3,:), a);
ed4 = extract_ed(Edof(4,:), a);
ed5 = extract_ed(Edof(5,:), a);

q1 = spring1s(ep1, ed1);
q2 = spring1s(ep2, ed2);
q3 = spring1s(ep3, ed3);
q4 = spring1s(ep4, ed4);
q5 = spring1s(ep5, ed5);

% Display the results
disp('Temperatures at nodes:');
disp(a);
disp('Heat flows at elements:');
disp([q1, q2, q3, q4, q5]);