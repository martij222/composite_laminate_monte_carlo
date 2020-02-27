clear; clc; close all;
%Monte Carlo simulation to estimate the stiffness matrices of a laminate
%with nominal lamina angles theta given the stochastic nature of the 
%material properties and lamina angles.
%% simulation parameters
tic
n_trials = 10000;
theta = [45, -45, 45, -45];
NL = length(theta);
sd = 3;

%% initialize arrays to store simulation results
A1 = zeros([3 3 n_trials]); B1 = zeros([3 3 n_trials]); D1 = zeros([3 3 n_trials]);
E1 = zeros([3 3 n_trials]); F1 = zeros([3 3 n_trials]); H1 = zeros([3 3 n_trials]);
A2 = zeros([2 2 n_trials]); D2 = zeros([2 2 n_trials]); F2 = zeros([2 2 n_trials]);
Qbar1 = zeros([3 3 NL n_trials]); Qbar2 = zeros([2 2 NL n_trials]); Z = zeros([NL+1 1 n_trials]); Theta = zeros([1 4 n_trials]);
E11 = zeros([NL 1 n_trials]); E22 = zeros([NL 1 n_trials]); G12 = zeros([NL 1 n_trials]); rho = zeros(n_trials, 1); 

for i=1:n_trials
    [ A1(:,:,i), B1(:,:,i), D1(:,:,i), ...
      E1(:,:,i), F1(:,:,i), H1(:,:,i), ...
      A2(:,:,i), D2(:,:,i), F2(:,:,i), ...
      Qbar1(:,:,:,i), Qbar2(:,:,:,i), Z(:,:,i), Theta(:,:,i), ...
      E11(:,:,i), E22(:,:,i), G12(:,:,i), rho(i)] = generatelaminate(theta, sd);
end
fprintf('Laminate Generation: '); toc

%% failure analysis
tic
% loading conditions Nx/y/xy [N/m], Mx/y/xy [Nm/m]
Nx = -10000; Ny = -10000; Nxy = 0; Mx = 0; My = 0; Mxy = 0;
F = [Nx; Ny; Nxy; Mx; My; Mxy];

% initialize strength ratio vectors
% maxstress_SR = zeros([1 n_trials]); tsai_hill_SR = zeros([1 n_trials]); mod_tsai_hill_SR = zeros([1 n_trials]);
strength_ratios = zeros(n_trials,4);
for i=1:n_trials
    global_strain = computeglobalstrain( F, A1(:,:,i), B1(:,:,i), D1(:,:,i), Z(:,:,i) ); 
    [maxlocalstress, maxlocalstrain] = ...
        computelocalmaxima( global_strain, Qbar1(:,:,:,i), Z(:,:,i), Theta(:,:,i), E11(:,:,i), E22(:,:,i), G12(:,:,i) );
    
    % compute ultimate strengths
    [ sig1_T_ult, sig1_C_ult, sig2_T_ult, sig2_C_ult, tau12_ult ] = generaterandomstrengths( sd );
    
    % failure theories
    strength_ratios(i,1) = maxstress( maxlocalstress, sig1_T_ult, sig1_C_ult, sig2_T_ult, sig2_C_ult, tau12_ult );
    strength_ratios(i,2) = maxstrain( maxlocalstrain, sig1_T_ult, sig1_C_ult, sig2_T_ult, sig2_C_ult, tau12_ult );
    strength_ratios(i,3) = tsai_hill( maxlocalstress, sig1_T_ult, sig2_T_ult, tau12_ult );
    strength_ratios(i,4) = mod_tsai_hill( maxlocalstress, sig1_T_ult, sig1_C_ult, sig2_T_ult, sig2_C_ult, tau12_ult );
end

fprintf('\nFailure Analysis: '); toc
fprintf('\nStrength Ratio Summary Statistics: \n');

statistics = statsummary( strength_ratios )

histogram(strength_ratios(:,1)); figure;
histogram(strength_ratios(:,2)); figure;
histogram(strength_ratios(:,3)); figure;
histogram(strength_ratios(:,4))