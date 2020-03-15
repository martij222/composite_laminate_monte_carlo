clear; clc; close all;
%Monte Carlo simulation to estimate the stiffness matrices of a laminate
%with nominal lamina angles theta given the stochastic nature of the 
%material properties and lamina angles.
%% simulation parameters
n_trials = 10000;
theta = [45, -45, 45, -45];
sd = 0:0.1:3;

% loading conditions Nx/y/xy [N/m], Mx/y/xy [Nm/m]
Nx = -10000; Ny = -10000; Nxy = 0; Mx = 0; My = 0; Mxy = 0;
F = [Nx; Ny; Nxy; Mx; My; Mxy];

% set seed for reproducibility
rng(0);

%% iterate through parameter selection
for i=1:length(sd)
    fprintf('\nSD = ' + string(sd(i)) + '\n')
    %% laminate generation
    tic    
    [ A1, B1, D1, ~, ~, ~, ~, ~, ~, Qbar1, ~, Z, Theta, E11, E22, G12, ply_thickness ] = ...
        stiffnessmatrixmontecarlo( theta, n_trials, sd(i) ); 
    fprintf('\nLaminate Generation: '); toc

    %% failure analysis
    tic
    T = generatesimulationdata(F, A1, B1, D1, Qbar1, Z, Theta, E11, E22, G12, ply_thickness, sd(i));
    fprintf('\nFailure Analysis: '); toc

    %% save data to csv
    % convert theta to string
    theta_str = "";
    
    for j=1:length(theta)
        theta_str = theta_str + string(theta(j));
    end
    
    filename = "n_trials_" + string(n_trials) ...
                + "_sd_" + string(sd(i)) ...
                + "_theta_ " + theta_str + ".csv";
            
    writetable(T,filename);
end
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
