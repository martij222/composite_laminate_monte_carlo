function [ sig1_T_ult, sig1_C_ult, sig2_T_ult, sig2_C_ult, tau12_ult ] = generaterandomstrengths( sd )
%generaterandomstrengths Generates random ultimate strengths assuming the
%material is graphite/epoxy
%   The nominal values are from Kaw, A. - Mechanics of Composite Materials:
%   Table 2.1 page 106. Standard deviations are assumed to be sd% of the
%   nominal values.

sig1_T_ult = 1e6*normrnd(1500, 1500*sd(1)/100);
sig1_C_ult = 1e6*normrnd(1500, 1500*sd(2)/100);
sig2_T_ult = 1e6*normrnd(40, 40*sd(3)/100);
sig2_C_ult = 1e6*normrnd(246, 246*sd(4)/100);
tau12_ult = 1e6*normrnd(68, 68*sd(5)/100);

end

