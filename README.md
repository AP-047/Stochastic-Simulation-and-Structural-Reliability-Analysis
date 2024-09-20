# Stochastic Simulation and Structural Reliability Analysis

This repository contains MATLAB code and results for a project on **Stochastic Simulation and Structural Reliability Analysis**, conducted during the Summer semester of 2024.

## Project Overview

This project focuses on evaluating the structural reliability of systems under uncertainty using **Finite Element Analysis (FEA)** and **Monte Carlo Simulation (MCS)**. The analysis incorporates **random material properties** to assess failure probabilities and reliability indices.

### Key Features:
- **Monte Carlo Simulation (MCS)** to estimate **failure probability (pf)** and **reliability index (β)** for structural systems.
- **Finite Element Analysis (FEA)** for heat flow and structural displacement analysis with random material properties.
- Implementation of **First Order Reliability Method (FORM)** and **Adaptive Kriging Monte Carlo Simulation (AK-MCS)** using **MATLAB** and **UQLab** frameworks.
- Convergence analysis of reliability methods to ensure accuracy in reliability estimates.

## Project Structure

- `/code/`: Contains MATLAB scripts for running the simulations and reliability analysis.
- `/results/`: Includes output results for reliability indices and probability of failure from the simulations.
- `/plots/`: Graphical outputs (displacement diagrams, reliability convergence plots, etc.).
- `/docs/`: Documentation files explaining the methodology and the interpretation of results.

## Installation & Usage

### Requirements:
- MATLAB R2023a or later
- UQLab (download from [UQLab Website](https://www.uqlab.com/))
