function [ E11, E22, v12, G23, G13, G12, rho, dtheta, t ] = generateproperties( )
%generateproperties Generate a set of random material properties.
%   Material properties are drawn from a random normal distribution with
%   means and standard deviations generated per Table 1.

E11 = 1e9*normrnd(16.48, 0.61);
E22 = 1e9*normrnd(1.4, 0.05);
G12 = 1e9*normrnd(0.87, 0.052);
G23 = 1e9*normrnd(0.45, 0.014);
G13 = 1e9*normrnd(0.87, 0.052);
v12 = normrnd(0.334, 0.01);
rho = normrnd(1000, 36);
dtheta = normrnd(0, 1.8);
t = normrnd(0.025, 0.001);

end

