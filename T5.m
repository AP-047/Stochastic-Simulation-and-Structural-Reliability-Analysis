% Initialize UQLab
uqlab;

% -------------------- Step 1: Define the probabilistic input model --------------------
Input.Marginals(1).Name = 'P';  % Force in kN
Input.Marginals(1).Type = 'Gaussian';
Input.Marginals(1).Parameters = [10 2];  % Mean = 10, StdDev = 2

Input.Marginals(2).Name = 'L';  % Length in m
Input.Marginals(2).Type = 'Gaussian';
Input.Marginals(2).Parameters = [8 0.1];  % Mean = 8, StdDev = 0.1

Input.Marginals(3).Name = 'W';  % Section modulus in m^3
Input.Marginals(3).Type = 'Gaussian';
Input.Marginals(3).Parameters = [100e-6 2e-5];  % Mean = 100e-6, StdDev = 2e-5

Input.Marginals(4).Name = 'T';  % Yield stress in kN/m^2
Input.Marginals(4).Type = 'Gaussian';
Input.Marginals(4).Parameters = [600e3 105e3];  % Mean = 600e3, StdDev = 105e3

% Create the input object
myInput = uq_createInput(Input);

% -------------------- Step 2: Define the limit-state function --------------------
ModelOpts.mFile = 'limit_state_function';  % Reference to the m-file function
myModel = uq_createModel(ModelOpts);  % Create the model object

% Limit state function in 'limit_state_function.m'
% function g = limit_state_function(X)
% P = X(:,1);
% L = X(:,2);
% W = X(:,3);
% T = X(:,4);
% g = W .* T - (P .* L) ./ 4;
% end

% -------------------- Step 3: Reliability Analysis Methods --------------------

% ------------- FORM Analysis -------------
FORMOpts.Type = 'Reliability';
FORMOpts.Method = 'FORM';
FORMOpts.Model = myModel;
FORMOpts.Input = myInput;
FORMOpts.LimitState.Threshold = 0;

% Ensure correct gradient calculation and improve accuracy
FORMOpts.Optim.TolX = 1e-6;  
FORMOpts.Optim.TolFun = 1e-6;  
FORMAnalysis = uq_createAnalysis(FORMOpts);

% Display the FORM results
fprintf('FORM Results:\n');
uq_print(FORMAnalysis);
uq_display(FORMAnalysis);

% ------------- MCS Analysis -------------
MCSOpts.Type = 'Reliability';
MCSOpts.Method = 'MCS';
MCSOpts.Model = myModel;
MCSOpts.Input = myInput;
MCSOpts.LimitState.Threshold = 0;

% Large sample size for better accuracy
MCSOpts.Simulation.BatchSize = 1e5;
MCSOpts.Simulation.MaxSampleSize = 1e7;  
MCSAnalysis = uq_createAnalysis(MCSOpts);

% Display the MCS results
fprintf('MCS Results:\n');
uq_print(MCSAnalysis);
uq_display(MCSAnalysis);

% ------------- Importance Sampling -------------
ISOpts.Type = 'Reliability';
ISOpts.Method = 'IS';
ISOpts.Model = myModel;
ISOpts.Input = myInput;
ISOpts.LimitState.Threshold = 0;
ISOpts.Simulation.MaxSampleSize = 1e6;

% Improve convergence
ISAnalysis = uq_createAnalysis(ISOpts);

% Display the Importance Sampling results
fprintf('Importance Sampling Results:\n');
uq_print(ISAnalysis);
uq_display(ISAnalysis);

% ------------- AK-MCS Analysis -------------
AKMCSOpts.Type = 'Reliability';
AKMCSOpts.Method = 'AKMCS';
AKMCSOpts.Model = myModel;
AKMCSOpts.Input = myInput;
AKMCSOpts.LimitState.Threshold = 0;

% Limiting the total number of samples
AKMCSOpts.Simulation.MaxSampleSize = 2e5;  % Limit the total sample size to 200,000
AKMCSOpts.StoppingCriterion.TargetCoV = 0.02;  % Adjust the CoV for early stopping
AKMCSOpts.StoppingCriterion.MaxAddedSamples = 10;  % Limit added samples per iteration

AKMCSAnalysis = uq_createAnalysis(AKMCSOpts);

% Display the AK-MCS results
fprintf('AK-MCS Results:\n');
uq_print(AKMCSAnalysis);
uq_display(AKMCSAnalysis);


% -------------------- End of Code --------------------
