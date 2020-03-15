function [ T ] = generatesimulationdata(F, A1, B1, D1, Qbar1, Z, Theta, E11, E22, G12, ply_thickness, sd)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% get number of layers and trials
[~, NL, n_trials] = size(E11);

% initialize arrays
strength_ratios = zeros(n_trials,6);
sig1_T_ult = zeros(n_trials,1); sig1_C_ult = zeros(n_trials,1);
sig2_T_ult = zeros(n_trials,1); sig2_C_ult = zeros(n_trials,1);
tau12_ult = zeros(n_trials,1);
max_stress_failure_ply = categorical(); max_stress_failure_mode = categorical(); 
max_strain_failure_ply = categorical(); max_strain_failure_mode = categorical();
for i=1:n_trials
    global_strain = computeglobalstrain( F, A1(:,:,i), B1(:,:,i), D1(:,:,i), Z(:,:,i) ); 
    [maxlocalstress, maxlocalstrain] = ...
        computelocalmaxima( global_strain, Qbar1(:,:,:,i), Z(:,:,i), Theta(:,:,i), E11(:,:,i), E22(:,:,i), G12(:,:,i) );
    
    % compute ultimate strengths
    [ sig1_T_ult(i), sig1_C_ult(i), sig2_T_ult(i), sig2_C_ult(i), tau12_ult(i) ] = generaterandomstrengths( sd );
    
    
    % failure theories
    [ strength_ratios(i,1), max_stress_failure_ply(i,1), max_stress_failure_mode(i,1) ] = maxstress( maxlocalstress, sig1_T_ult(i), sig1_C_ult(i), sig2_T_ult(i), sig2_C_ult(i), tau12_ult(i) );
    [ strength_ratios(i,2), max_strain_failure_ply(i,1), max_strain_failure_mode(i,1) ] = maxstrain( maxlocalstrain, sig1_T_ult(i), sig1_C_ult(i), sig2_T_ult(i), sig2_C_ult(i), tau12_ult(i) );
    strength_ratios(i,3) = tsai_hill( maxlocalstress, sig1_T_ult(i), sig2_T_ult(i), tau12_ult(i) );
    strength_ratios(i,4) = mod_tsai_hill( maxlocalstress, sig1_T_ult(i), sig1_C_ult(i), sig2_T_ult(i), sig2_C_ult(i), tau12_ult(i) );
    [ strength_ratios(i,5), strength_ratios(i,6) ] = tsai_wu( maxlocalstress, sig1_T_ult(i), sig1_C_ult(i), sig2_T_ult(i), sig2_C_ult(i), tau12_ult(i) );
end

% reshape material property matrices to facilitate data analysis
E11 = reshape( permute(E11,[3 1 2]),[n_trials NL]);
E22 = reshape( permute(E22,[3 1 2]),[n_trials NL]);
G12 = reshape( permute(G12,[3 1 2]),[n_trials NL]);
Theta = reshape( permute(Theta,[3 1 2]) ,[n_trials NL]);
ply_thickness = reshape( permute(ply_thickness,[3 1 2]),[n_trials NL]);
N = repelem(n_trials, n_trials)'; SD = repelem(sd, n_trials)';

% assign strength ratios to separate variables
max_stress_SR = strength_ratios(:,1); max_strain_SR = strength_ratios(:,2);
tsai_hill_SR = strength_ratios(:,3); mod_tsai_hill_SR = strength_ratios(:,4);
tsai_wu_H_SR = strength_ratios(:,5); tsai_wu_MH_SR = strength_ratios(:,6);

T = table(N, SD, E11, E22, G12, Theta, ply_thickness, ...
          max_stress_failure_mode, max_stress_failure_ply, ...
          max_strain_failure_mode, max_strain_failure_ply, ...
          sig1_T_ult, sig1_C_ult, sig2_T_ult, sig2_C_ult, tau12_ult, ...
          max_stress_SR, max_strain_SR, tsai_hill_SR, mod_tsai_hill_SR, ...
          tsai_wu_H_SR, tsai_wu_MH_SR);

end

