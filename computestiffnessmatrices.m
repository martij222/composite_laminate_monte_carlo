function [ A1, B1, D1, E1 F1, H1, A2, D2, F2 ] = computestiffnessmatrices( Q_bar1, Q_bar2, z )
%computestiffnessmatrices Extensional, coupling, and bending stiffness matrices.
%   Q_bari is an array of transformed reduced stiffness matrices in the form Q_bari =
%   [Q_bar1 Q_bar2 ... Q_barNL], where NL is the number of laminae.
%   h is an array of the z-coordinates of each lamina.

% Find number of layers
NL = length(Q_bar1);

% Initialize stiffness matrices
A1 = zeros(3); B1 = zeros(3); D1 = zeros(3); E1 = zeros(3); F1 = zeros(3); H1 = zeros(3);
A2 = zeros(2); D2 = zeros(2); F2 = zeros(2);

% Compute stiffness matrices (i,j=1,2,6)
for k=1:NL
    A1 = A1 + Q_bar1(:,:,k) * (z(k+1)-z(k));
    B1 = B1 + (1/2)*Q_bar1(:,:,k) * (z(k+1)^2-z(k)^2);
    D1 = D1 + (1/3)*Q_bar1(:,:,k) * (z(k+1)^3-z(k)^3);
    E1 = E1 + (1/4)*Q_bar1(:,:,k) * (z(k+1)^4-z(k)^4);
    F1 = F1 + (1/5)*Q_bar1(:,:,k) * (z(k+1)^5-z(k)^5);
    H1 = H1 + (1/7)*Q_bar1(:,:,k) * (z(k+1)^7-z(k)^7);
end

% Compute stiffness matrices (i,j=4,5)
for k=1:NL
    A2 = A2 + Q_bar2(:,:,k) * (z(k+1)-z(k));
    D2 = D2 + (1/3)*Q_bar2(:,:,k) * (z(k+1)^3-z(k)^3);
    F2 = F2 + (1/5)*Q_bar2(:,:,k) * (z(k+1)^5-z(k)^5);
end

end

