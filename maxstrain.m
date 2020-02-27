function [ maxstrain_SR ] = maxstrain( local_strain, sig1_T_ult, sig1_C_ult, sig2_T_ult, sig2_C_ult, tau12_ult )
%maxstrain Compute strength ratio using maximum strain failure theory
%   local_stress is a vector of stresses in the local ply coordinate
%   system in the form [sig1 sig2 tau12]. The remaining arguments are the ultimate compressive, tensile, and shear
%   strengths of the lamina.

eps1_T_ult = sig1_T_ult/local_strain(1,1,2); eps1_C_ult = sig1_C_ult/local_strain(1,1,2);
eps2_T_ult = sig2_T_ult/local_strain(2,1,2); eps2_C_ult = sig2_C_ult/local_strain(2,1,2);
gamma12_ult = tau12_ult/local_strain(3,1,2);

sr1_C = -eps1_C_ult/local_strain(1); sr1_T = eps1_T_ult/local_strain(1); % direction 1
sr2_C = -eps2_C_ult/local_strain(2); sr2_T = eps2_T_ult/local_strain(2); % direction 2
sr12 = gamma12_ult/abs( local_strain(3) ); % shear

temp = [sr1_C sr1_T sr2_C sr2_T sr12];
pos_ratios = temp(temp > 0); % get positive ratios only

maxstrain_SR = min(pos_ratios);

end

