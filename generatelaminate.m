function [ A1, B1, D1, E1, F1, H1, A2, D2, F2 ] = generatelaminate( theta )
%generatelaminate Generate a laminate.
%   Lamina angles are contained in input theta per conventional laminate
%   code.

NL = length(theta); % number of layers

% initialize arrays to accumulate layer thicknesses and transformed reduced
% stiffness matrices
layerthicknesses = []; Q_bar1 = []; Q_bar2 = [];
layerthicknesses=zeros(1,NL);
for i=1:NL
    [ E11, E22, v12, G23, G13, G12, rho, dtheta, ti ] = generateproperties;
    [ Q_bar1i, Q_bar2i ] = computeQbar( E11, E22, v12, G23, G13, G12, theta(i)+dtheta );
    
    % append to existing arrays
    layerthicknesses(i)=ti;
    Q_bar1 = [Q_bar1, Q_bar1i]; Q_bar2 = [Q_bar2, Q_bar2i]; 
end

z = computecoords(layerthicknesses);
[ A1, B1, D1, E1, F1, H1, A2, D2, F2 ] = computestiffnessmatrices( Q_bar1, Q_bar2, z );

end

