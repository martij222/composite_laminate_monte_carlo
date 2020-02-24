function [ maxlocalstress, maxlocalstrain ] = computelocalmaxima( global_strain, Qbar, z, theta )
%computelocalmaxima Compute local stresses and strains at the top and bottom surfaces
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
maxepsilon1 = max( local_strain(1,1,:) );
maxepsilon2 = max( local_strain(2,1,:) );
maxgamma12 = max( local_strain(3,1,:) );
maxlocalstrain = [maxepsilon1; maxepsilon2; maxgamma12];

% stress
maxsigma1 = max( local_stress(1,1,:) );
maxsigma2 = max( local_stress(2,1,:) );
maxtau12 = max( local_stress(3,1,:) );
maxlocalstress = [maxsigma1; maxsigma2; maxtau12];

end