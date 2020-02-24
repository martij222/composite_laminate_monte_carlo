function [ global_strain ] = computeglobalstrain( F, A, B, D, z )
%computeglobalstrain Global strain values for a composite laminate plate.
%   F is the external loading in the form [Nx; Ny; Nxy; Mx; My; Mxy].
%   A, B, and D are the extensional, coupling, and bending stiffness
%   matrices, respectively. z is a vector of the vertical coordinates of
%   the top and bottom surfaces of each ply.

%% compute midplane strains and curvatures
K = [A B; B D]; % stiffness matrix
mp_strain = K \ F; % midplane values

%% compute global strain
% number of coordinates at which to compute strain
n = length(z);

global_strain = zeros([3 1 n]); % initialize matrix of strain values
for i=1:n
    global_strain(:,:,i) = mp_strain(1:3) + z(i) * mp_strain(4:6);
end

end

