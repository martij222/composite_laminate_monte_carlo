function [ A1, B1, D1, E1, F1, H1, A2, D2, F2, Q_bar1, Q_bar2, z, theta, E11, E22, G12, rho ] = generatelaminate( theta, sd )
%generatelaminate Generate a laminate.
%   Lamina angles are contained in input theta per conventional laminate
%   code. Qbars, z, and theta are passed for failure analysis.

NL = length(theta); % number of layers

% initialize arrays to accumulate material properties and transformed reduced
% stiffness matrices
E11 = zeros(NL,1); E22 = zeros(NL,1); G12 = zeros(NL,1); rho = zeros(NL,1);
layerthicknesses = zeros(NL,1); Q_bar1 = zeros([3 3 NL]); Q_bar2 = zeros([2 2 NL]);

for i=1:NL
    % generate random material properties
    [ E11i, E22i, v12, G23, G13, G12i, rhoi, dtheta, ti ] = generateproperties(sd);
    
    % accumulate data into appropriate arrays
    E11(i) = E11i; E22(i) = E22i; G12(i) = G12i; rho(i) = rhoi;
    theta(i) = theta(i)+dtheta;
    layerthicknesses(i)=ti;
    
    % Compute transformed reduced stiffness matrices
    [ Q_bar1(:,:,i), Q_bar2(:,:,i) ] = computeQbar( E11i, E22i, v12, G23, G13, G12i, theta(i) );
end

rho = sum(rho .* layerthicknesses) / sum(layerthicknesses); % composite density (weighted average)
z = computecoords(layerthicknesses); % compute horizontal coordinates with midplane z=0
[ A1, B1, D1, E1, F1, H1, A2, D2, F2 ] = computestiffnessmatrices( Q_bar1, Q_bar2, z );

end

