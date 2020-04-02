clear; clc; close all;
%Monte Carlo simulation to estimate the stiffness matrices of a laminate
%with nominal lamina angles theta given the stochastic nature of the 
%material properties and lamina angles.
%% simulation parameters
n_trials = 10000;
theta = [45, -45, 45, -45];

% loading conditions Nx/y/xy [N/m], Mx/y/xy [Nm/m]
Nx = -10000; Ny = -10000; Nxy = 0; Mx = 0; My = 0; Mxy = 0;
F = [Nx; Ny; Nxy; Mx; My; Mxy];

%% specify sds for each simulation for which to generate data
a = 0:2; % simulate for all combinations of sd = 0, 1, 2
cov11 = combvec(a,a,a,a,a,a); cov12 = zeros([5 729]);
cov21 = zeros([6, 243]); cov22 = combvec(a,a,a,a,a);
sim1 = vertcat(cov11,cov12); % material properties random, strengths deterministic
sim2 = vertcat(cov21,cov22); % material properties deterministic, strengths random
sd = horzcat(sim1,sim2); % [E11 E22 G12 v12 dtheta t] [sig1_T_ult sig1_C_ult sig2_T_ult sig2_C_ult tau12_ult]
% a = 0.1:0.1:3;
% sd = reshape( repelem(a',11),[11 30] );

%% iterate through parameter selection
rng(0); % set seed for reproducibility
n_sims = length(sd);
t1 = zeros([n_sims 1]); t2 = zeros([n_sims 1]); % arrays to store simulation times
for i=1:n_sims
    fprintf('\nRun ' + string(i) + '\n');
    %% laminate generation
    tic
    [ A1, B1, D1, ~, ~, ~, ~, ~, ~, Qbar1, ~, Z, Theta, E11, E22, G12, ply_thickness ] = ...
        stiffnessmatrixmontecarlo( theta, n_trials, sd(1:6,i) ); 
    t1(i) = toc;

    %% failure analysis
    tic
    T = generatesimulationdata( F, A1, B1, D1, Qbar1, Z, Theta, E11, E22, G12, ply_thickness, sd(:,i) );
    t2(i) = toc;

    %% save data to csv
    % convert theta to string
    theta_str = "";
    
    for j=1:length(theta)
        theta_str = theta_str + string(theta(j));
    end
    
%     filename = "simulation_" + string(i) ...
%                 + "_theta_ " + theta_str + ".csv";
    filename = "n_trials_" + string(n_trials) ...
                 + "_sd_" + string(sd(1,i)) ...
                 + "_theta_ " + theta_str + ".csv";
            
    writetable(T,"Simulation Data\" + filename);
end
fprintf('\nTotal time elapsed: ' + string( sum(t2+t1) ) + ' seconds\n');
%% statistics
%fprintf('\nStrength Ratio Summary Statistics: \n');
%
% summarize strength ratio statistics
% statistics = statsummary( strength_ratios );
% disp(statistics)
% 
% % plot histograms for strength ratio comparison
% hold on;
% histogram(strength_ratios(:,1)); histogram(strength_ratios(:,2));
% histogram(strength_ratios(:,3)); histogram(strength_ratios(:,4));
% histogram(strength_ratios(:,5)); histogram(strength_ratios(:,6));
% legend({'max stress','max strain','tsai-hill','modified tsai-hill','tsai-wu (Hoffman)','tsai-wu (Mises-Hencky)'})
% title('Histogram Comparison of Failure Theories')
% xlabel('Strength Ratio'); ylabel('Frequency');
% hold off;
% 
% % plot boxplots for ratio comparison
% figure;
% boxplot(strength_ratios, 'labels',{'max stress','max strain','tsai-hill','modified tsai-hill','tsai-wu (Hoffman)','tsai-wu (Mises-Hencky)'})
% hold on; plot(mean(strength_ratios), 'dg'); hold off;
% title('Boxplot Comparison of Failure Theories')
% ylabel('Strength Ratio'); xtickangle(45);
