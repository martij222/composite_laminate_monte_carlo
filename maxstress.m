function [ maxstress_SR ] = maxstress( local_stress, sig1_T_ult, sig1_C_ult, sig2_T_ult, sig2_C_ult, tau12_ult )
%maxstress Compute strength ratio using maximum stress failure theory
%   local_stress is a vector of stresses in the local ply coordinate
%   system in the form [sig1 sig2 tau12]. The remaining arguments are the ultimate compressive, tensile, and shear
%   strengths of the lamina.

sr1_C = -sig1_C_ult/local_stress(1); sr1_T = sig1_T_ult/local_stress(1); % direction 1
sr2_C = -sig2_C_ult/local_stress(2); sr2_T = sig2_T_ult/local_stress(2); % direction 2
sr12 = tau12_ult/abs( local_stress(3) ); % shear

temp = [sr1_C sr1_T sr2_C sr2_C sr12];
pos_ratios = temp(temp > 0); % get positive ratios only

maxstress_SR = min(pos_ratios);

end

