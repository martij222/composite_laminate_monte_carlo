clear; clc; close all;
%Monte Carlo simulation to estimate the stiffness matrices of a laminate
%with nominal lamina angles theta given the stochastic nature of the 
%material properties and lamina angles.
tic
%% simulation parameters
n_trials = 10000;
theta = [0, 90, 90, 0];

%% initialize arrays to store simulation results
A1 = zeros([3 3 n_trials]); B1 = zeros([3 3 n_trials]); D1 = zeros([3 3 n_trials]);
E1 = zeros([3 3 n_trials]); F1 = zeros([3 3 n_trials]); H1 = zeros([3 3 n_trials]);
A2 = zeros([2 2 n_trials]); D2 = zeros([2 2 n_trials]); F2 = zeros([2 2 n_trials]);

for i=1:n_trials
    [ A1(:,:,i), B1(:,:,i), D1(:,:,i), ...
      E1(:,:,i), F1(:,:,i), H1(:,:,i), ...
      A2(:,:,i), D2(:,:,i), F2(:,:,i) ] = generatelaminate(theta);
end
toc

%% assume N, M > find midplane strain, curvature > compute local stress > laminate failure theory
% 