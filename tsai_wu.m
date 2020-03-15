function [ tsai_wu_H_SR, tsai_wu_MH_SR ] = tsai_wu( local_stress, sig1_T_ult, sig1_C_ult, sig2_T_ult, sig2_C_ult, tau12_ult )
%tsai_wu Compute strength ratio using Tsai-Wu failure theory (Hoffman and
%Mises-Hencky criteria)
%   local_stress is a vector of stresses in the local ply coordinate
%   system in the form [sig1 sig2 tau12]. The remaining arguments are the ultimate tensile and shear
%   strengths of the lamina.

% coefficients
H1 = sig1_T_ult^-1 - sig1_C_ult^-1; H11 = (sig1_T_ult * sig1_C_ult)^-1;
H2 = sig2_T_ult^-1 - sig2_C_ult^-1; H22 = (sig2_T_ult * sig2_C_ult)^-1;
H6 = 0; H66 = (tau12_ult)^-2;

H12_H = -(2*sig1_T_ult * sig1_C_ult)^-1;
H12_MH = -0.5 * 1/sqrt( sig1_T_ult * sig1_C_ult * sig2_T_ult * sig2_C_ult );

% find roots of quadratic inequality
a_H = H11*local_stress(1)^2 + H22*local_stress(2)^2 + H66*local_stress(3)^2 + 2*H12_H*local_stress(1)*local_stress(2);
a_MH = H11*local_stress(1)^2 + H22*local_stress(2)^2 + H66*local_stress(3)^2 + 2*H12_MH*local_stress(1)*local_stress(2); 
b = H1*local_stress(1) + H2*local_stress(2) + H6*local_stress(3); c = -1;
sr_H = roots( [a_H b c] ); sr_H = sr_H(sr_H > 0);
sr_MH = roots( [a_MH b c] ); sr_MH = sr_H(sr_MH > 0);

% return minimum SR
tsai_wu_H_SR = min(sr_H); % Hoffman criterion
tsai_wu_MH_SR = min(sr_MH); % Mises-Hencky criterion

end

