% Task 2 - Part 1: Adaptation with Random Young's Modulus

echo on 

%----- Topology matrix Edof -------------------------------------
Edof = [1 1 2 5 6;
        2 5 6 7 8;
        3 3 4 5 6];
 
%----- Stiffness matrix K and load vector f ---------------------
K = zeros(8); 
f = zeros(8,1); f(6) = -80e3; % Load

%----- Random Young's Modulus for the 3 bars ---------------------
mu_E = 200e9; % Mean Young's Modulus in Pascals (200 GPa)
sigma_E = 10e9; % Standard deviation in Pascals (10 GPa)
theta = 10; % Correlation length (not used directly here for simplicity)

% Generate random Young's modulus for each bar
E_random = normrnd(mu_E, sigma_E, [1, 3]); % Random E values for 3 bars

A1 = 6.0e-4; A2 = 3.0e-4; A3 = 10.0e-4; % Cross-sectional areas of the bars

% Assign element properties with random Young's modulus
ep1 = [E_random(1) A1];
ep2 = [E_random(2) A2];
ep3 = [E_random(3) A3];

%----- Element coordinates --------------------------------------
ex1 = [0 1.6]; ey1 = [0 0]; % Coordinates for element 1
ex2 = [1.6 1.6]; ey2 = [0 1.2]; % Coordinates for element 2
ex3 = [0 1.6]; ey3 = [1.2 0]; % Coordinates for element 3

%----- Element stiffness matrices -------------------------------
Ke1 = bar2e(ex1, ey1, ep1);	 
Ke2 = bar2e(ex2, ey2, ep2);
Ke3 = bar2e(ex3, ey3, ep3);

%----- Assemble Ke into K ---------------------------------------
K = assem(Edof(1,:), K, Ke1);
K = assem(Edof(2,:), K, Ke2); 
K = assem(Edof(3,:), K, Ke3);

%----- Solve the system of equations ----------------------------
bc = [1 0; 2 0; 3 0; 4 0; 7 0; 8 0]; % Boundary conditions (fixed supports)
[a, r] = solveq(K, f, bc);

%----- Element forces -------------------------------------------
ed1 = extract_ed(Edof(1,:), a);
N1 = bar2s(ex1, ey1, ep1, ed1);
ed2 = extract_ed(Edof(2,:), a);
N2 = bar2s(ex2, ey2, ep2, ed2);
ed3 = extract_ed(Edof(3,:), a);	
N3 = bar2s(ex3, ey3, ep3, ed3);

%----- Display random Young's modulus and forces in the command window -----
disp('Random Young''s Modulus values (GPa):');
disp(E_random / 1e9); % Convert to GPa for display

% Display only the axial force in each element (1st entry)
disp('Element Forces (N):');
disp(['N1 = ', num2str(N1(1)), ' N']);
disp(['N2 = ', num2str(N2(1)), ' N']);
disp(['N3 = ', num2str(N3(1)), ' N']);

%----- Draw deformed truss ---------------------------------------
figure(1)
plotpar = [2 1 0];
eldraw2(ex1, ey1, plotpar);
eldraw2(ex2, ey2, plotpar);
eldraw2(ex3, ey3, plotpar);
sfac = scalfact2(ex1, ey1, ed1, 0.1);
plotpar = [1 2 1];
eldisp2(ex1, ey1, ed1, plotpar, sfac);
eldisp2(ex2, ey2, ed2, plotpar, sfac);
eldisp2(ex3, ey3, ed3, plotpar, sfac);
axis([-0.4 2.0 -0.4 1.4]); 
scalgraph2(sfac, [1e-3 0 -0.3]);
title('Displacements')

%----- Draw normal force diagram --------------------------------
figure(2)
plotpar = [2 1];
sfac = scalfact2(ex1, ey1, N2(:,1), 0.1);
secforce2(ex1, ey1, N1(:,1), plotpar, sfac);
secforce2(ex2, ey2, N2(:,1), plotpar, sfac);
secforce2(ex3, ey3, N3(:,1), plotpar, sfac);
axis([-0.4 2.0 -0.4 1.4]);
scalgraph2(sfac, [5e4 0 -0.3]);
title('Normal force')

echo off