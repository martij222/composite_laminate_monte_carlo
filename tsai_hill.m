function [ tsai_hill_SR ] = tsai_hill( local_stress, sig1_T_ult, sig2_T_ult, tau12_ult )
%tsai_hill Compute strength ratio using Tsai-Hill failure theory
%   local_stress is a vector of stresses in the local ply coordinate
%   system in the form [sig1 sig2 tau12]. The remaining arguments are the ultimate tensile and shear
%   strengths of the lamina.

c = (local_stress(1)/sig1_T_ult)^2 ...
    - (local_stress(1)*local_stress(2)/ sig1_T_ult^2) ...
    + (local_stress(2)/sig2_T_ult)^2 ...
    + (local_stress(3)/tau12_ult)^2;

tsai_hill_SR = c^-.5;

end

