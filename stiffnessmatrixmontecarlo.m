function [ A1, B1, D1, E1, F1, H1, A2, D2, F2 ] = stiffnessmatrixmontecarlo( theta, n_trials )
%stiffnessmatrixmontecarlo Monte Carlo simulation to estimate the
%stiffness matrices of a laminate with nominal lamina angles theta given
%the stochastic nature of the material properties and lamina angles.

% initialize arrays to store simulation results
A1 = zeros([3 3 n_trials]); B1 = zeros([3 3 n_trials]); D1 = zeros([3 3 n_trials]);
E1 = zeros([3 3 n_trials]); F1 = zeros([3 3 n_trials]); H1 = zeros([3 3 n_trials]);
A2 = zeros([2 2 n_trials]); D2 = zeros([2 2 n_trials]); F2 = zeros([2 2 n_trials]);
for i=1:n_trials
    [ A1i, B1i, D1i, E1i, F1i, H1i, A2i, D2i, F2i ] = generatelaminate(theta);
    A1(:,:,i) = A1i; B1(:,:,i) = B1i; D1(:,:,i) = D1i;
    E1(:,:,i) = E1i; F1(:,:,i) = F1i; H1(:,:,i) = H1i;
    A2(:,:,i) = A2i; D2(:,:,i) = D2i; F2(:,:,i) = F2i;
end

end

