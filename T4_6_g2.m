function T4_6_g2
    % Initialize UQLab framework
    uqlab;

    %% 1 - Define the probabilistic input model
    InputOpts.Marginals(1).Type = 'Gaussian';
    InputOpts.Marginals(1).Moments = [10 3];  % Mean and standard deviation for X1
    InputOpts.Marginals(2).Type = 'Exponential';
    InputOpts.Marginals(2).Parameters = 1;  % Lambda for Exponential distribution (X2 ~ Exp(1))

    myInput = uq_createInput(InputOpts);

    %% 2 - Define the limit state function (g2) inline instead of external file
    ModelOpts.mString = 'X(:,1).^2 - X(:,2).^3 + 23';  % The limit state function g2
    myModel = uq_createModel(ModelOpts);

    %% 3 - FORM analysis for g2
    FORMOpts_g2.Type = 'Reliability';
    FORMOpts_g2.Method = 'FORM';
    FORMOpts_g2.Input = myInput;
    FORMOpts_g2.Model = myModel;

    % Run FORM analysis
    myFORMAnalysis_g2 = uq_createAnalysis(FORMOpts_g2);

    % Display FORM results
    uq_print(myFORMAnalysis_g2);
    uq_display(myFORMAnalysis_g2);

    %% 4 - Monte Carlo Simulation (MCS) analysis for g2
    MCSOpts_g2.Type = 'Reliability';
    MCSOpts_g2.Method = 'MCS';
    MCSOpts_g2.Simulation.BatchSize = 1e4;
    MCSOpts_g2.Simulation.MaxSampleSize = 1e5;
    MCSOpts_g2.Input = myInput;
    MCSOpts_g2.Model = myModel;

    % Run MCS analysis
    myMCSAnalysis_g2 = uq_createAnalysis(MCSOpts_g2);

    % Display MCS results
    uq_print(myMCSAnalysis_g2);
    uq_display(myMCSAnalysis_g2);
end