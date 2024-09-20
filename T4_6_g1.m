% Initialize UQLab
uqlab;

%% Step 1: Define the limit state function g1 = 3*X1 - 2*X2 + 18

% Define the ModelOpts structure for g1
ModelOpts.mString = '3 * X(:,1) - 2 * X(:,2) + 18';  % g1 function as a string
ModelOpts.isVectorized = true;  % Allow vectorized evaluation
myModel = uq_createModel(ModelOpts);  % Create the model

%% Step 2: Define the probabilistic input model for g1
% X1 ~ N(12, 5), X2 ~ N(10, 9)
InputOpts.Marginals(1).Type = 'Gaussian';  % X1 is Gaussian
InputOpts.Marginals(1).Parameters = [12, 5];  % Mean = 12, Std = 5

InputOpts.Marginals(2).Type = 'Gaussian';  % X2 is Gaussian
InputOpts.Marginals(2).Parameters = [10, 9];  % Mean = 10, Std = 9

myInput = uq_createInput(InputOpts);  % Create the probabilistic input model

%% Step 3: Set up and run the FORM analysis for g1
FORMOpts.Type = 'Reliability';
FORMOpts.Method = 'FORM';
FORMOpts.Model = myModel;  % Link to g1 model
FORMOpts.Input = myInput;  % Link to input model
myFORMAnalysis_g1 = uq_createAnalysis(FORMOpts);  % Run FORM analysis

% Print and display results of FORM analysis
uq_print(myFORMAnalysis_g1);
uq_display(myFORMAnalysis_g1);

%% Step 4: Run Monte Carlo Simulation (MCS) for g1
MCSOpts.Type = 'Reliability';
MCSOpts.Method = 'MCS';  % Monte Carlo Simulation
MCSOpts.Model = myModel;  % Link to g1 model
MCSOpts.Input = myInput;  % Link to input model
MCSOpts.Simulation.MaxSampleSize = 1e5;  % Set a maximum number of samples (e.g., 100,000)
MCSOpts.Simulation.BatchSize = 1e3;  % Set batch size to control how samples are taken

myMCSAnalysis_g1 = uq_createAnalysis(MCSOpts);  % Run MCS analysis

% Print and display results of MCS analysis
uq_print(myMCSAnalysis_g1);
uq_display(myMCSAnalysis_g1);