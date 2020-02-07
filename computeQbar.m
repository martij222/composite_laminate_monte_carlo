function [ Q_bar1, Q_bar2 ] = computeQbar( E11, E22, v12, G23, G13, G12, theta )
%computeQbar Transformed reduced stiffness matrices for given lamina material
%properties and angle theta[deg].
%   Elements are calculated per Appendix A.

% Stiffness elements
v21 = (E22/E11) * v12; d = 1 - v12*v21; 
Q11 = E11/d; Q22 = E22/d; Q12 = v12*E22/d;
Q44 = G23; Q55 = G13; Q66 = G12;

% Lamina invariants
U1 = (3*Q11 + 3*Q22 + 2*Q12 + 4*Q66)/8; U2 = (Q11-Q22)/2; U3 = (Q11 + Q22 - 2*Q12 - 4*Q66)/8;
U4 = (Q11 + Q22 + 6*Q12 - 4*Q66)/8; 
U5 = (Q44-Q55)/2; U6 = (Q44+Q55)/2;

% Q_bar elements
theta = theta * (pi/180);
Qb11 = U1 + U2*cos(2*theta) + U3*cos(4*theta);
Qb22 = U1 - U2*cos(2*theta) + U3*cos(4*theta);
Qb12 = U4 - U3*cos(4*theta);
Qb66 = (1/2)*(U1 - U4) - U3*cos(4*theta);
Qb16 = (1/2)*U2*sin(2*theta) + U3*sin(4*theta);
Qb26 = (1/2)*U2*sin(2*theta) - U3*sin(4*theta);
Qb44 = U6 + U5*cos(2*theta);
Qb55 = U6 - U5*cos(2*theta);
Qb45 = -U5*sin(2*theta);

% Transformed reduced stiffness matrices
Q_bar1 = [Qb11 Qb12 Qb16;
         Qb12 Qb22 Qb26;
         Qb16 Qb26 Qb66];

Q_bar2 = [Qb44 Qb45;
          Qb45 Qb55];
end

