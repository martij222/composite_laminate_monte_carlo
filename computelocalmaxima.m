function [ maxlocalstress, maxlocalstrain ] = computelocalmaxima( global_strain, Qbar, z, theta, E11, E22, G12 )
%computelocalmaxima Compute maxim local stresses and strains at the top and bottom surfaces
%of each ply in the laminate.
%   global_strain is a [3 3 NL] matrix of global strain values. Qbar is a
%   [3 3 NL] matrix of transformed reduced stiffness matrices for each ply.
%   z and theta are vertical ply surface coordinates and ply angles,
%   respectively.

[~,~,NL] = size(Qbar); % number of layers
%% global stress calculations
global_stress = zeros([3 1 0]); % initialize global stress matrix
for i=1:NL
    % compute stress for ith ply
    plystress = computeglobalsurfacestress( Qbar(:,:,i), global_strain(:,:,[i i+1]) );
    
    % append to global_stress matrix
    global_stress = cat(3,global_stress,plystress);
end

%% local stress and strain calculations
% transformation matrices
T = zeros([3 3 NL]); % initialize
for i=1:NL
    T(:,:,i) = computetransformationmatrix( theta(i) );
end

% strain
local_strain = zeros([3 1 0]);
for i=1:NL
    % compute strain for ith ply
    plystrain = computelocalsurfacestrain( T(:,:,i), global_strain(:,:,[i i+1]) );
    
    % append to local_strain matrix
    local_strain = cat(3,local_strain,plystrain);
end

% stress
T = repelem(T, 1, 1, 2); % repeat each matrix twice for stress calculation
local_stress = zeros([3 1 2*NL]); % initialize local stress matrix
for i=1:2*NL
    local_stress(:,:,i) = T(:,:,i) * global_stress(:,:,i);
end

%% max stress and strain

% strain
[maxepsilon1, eps1_i ] = max( local_strain(1,1,:) );
[maxepsilon2, eps2_i ] = max( local_strain(2,1,:) );
[maxgamma12, gamma12_i ] = max( local_strain(3,1,:) );

temp = repelem(1:NL,2); % matrix of ply numbers
E11 = E11( temp(eps1_i) ); E22 = E22( temp(eps2_i) ); G12 = G12( temp(gamma12_i) ); % ply properties corresponding to maximum strain

maxlocalstrain = zeros([3 1 3]); % initialize matrix
maxlocalstrain(:,:,1) = [maxepsilon1; maxepsilon2; maxgamma12]; % assign strain vector to first 3d index
maxlocalstrain(:,:,2) = [E11; E22; G12]; % assign corresponding properties to second 3d index
maxlocalstrain(:,:,3) = [temp(eps1_i); temp(eps2_i); temp(gamma12_i)]; % ply numbers

% stress
maxlocalstress = zeros([3 1 2]);
[maxsigma1, sig1_i] = max( local_stress(1,1,:) );
[maxsigma2, sig2_i] = max( local_stress(2,1,:) );
[maxtau12, tau12_i] = max( local_stress(3,1,:) );
maxlocalstress(:,:,1) = [maxsigma1; maxsigma2; maxtau12];
maxlocalstress(:,:,2) = [temp(sig1_i); temp(sig2_i); temp(tau12_i)];
end