function [ E11, E22, v12, G23, G13, G12, rho, dtheta, t ] = generateproperties( sd )
%generateproperties Generate a set of random material properties.
%   Material properties are drawn from a random normal distribution with
%   means and standard deviations generated per Table 1.

E11 = 1e6*normrnd(181, 181*sd(1)/100); %1e9*normrnd(16.48, 0.61);
E22 = 1e6*normrnd(10.30, 10.30*sd(2)/100); %1e9*normrnd(1.4, 0.05);
G12 = 1e6*normrnd(7.17, 7.17*sd(3)/100); %1e9*normrnd(0.87, 0.052);
v12 = normrnd(0.28, 0.28*sd(4)/100); %normrnd(0.334, 0.01);
dtheta = normrnd(0, 50*sd(5)/100); % 0.5deg sd per point
t = normrnd(0.025, 0.025*sd(6)/100);

% for CMES paper
G23 = 1e9*normrnd(0.45, 0.014);
G13 = 1e9*normrnd(0.87, 0.052);
rho = normrnd(1000, 36);

end

