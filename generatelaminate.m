function [ A1, B1, D1, E1, F1, H1, A2, D2, F2, Q_bar1, Q_bar2, z, theta ] = generatelaminate( theta )
%generatelaminate Generate a laminate.
%   Lamina angles are contained in input theta per conventional laminate
%   code. Qbars, z, and theta are passed for failure analysis.

NL = length(theta); % number of layers

% initialize arrays to accumulate layer thicknesses and transformed reduced
% stiffness matrices
layerthicknesses = zeros(1,NL); Q_bar1 = zeros([3 3 NL]); Q_bar2 = zeros([2 2 NL]);

for i=1:NL
    % generate random material properties
    [ E11, E22, v12, G23, G13, G12, rho, dtheta, ti ] = generateproperties;
    
    % Compute transformed reduced stiffness matrices and accumulate into
    % appropriate arrays 
    theta(i) = theta(i)+dtheta;
    layerthicknesses(i)=ti;
    [ Q_bar1(:,:,i), Q_bar2(:,:,i) ] = computeQbar( E11, E22, v12, G23, G13, G12, theta(i) );
end

z = computecoords(layerthicknesses); % compute horizontal coordinates with midplane z=0
[ A1, B1, D1, E1, F1, H1, A2, D2, F2 ] = computestiffnessmatrices( Q_bar1, Q_bar2, z );

end

