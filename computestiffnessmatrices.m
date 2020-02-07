function [ A1, B1, D1, E1 F1, H1, A2, D2, F2 ] = computestiffnessmatrices( Q_bar1, Q_bar2, z )
%computestiffnessmatrices Extensional, coupling, and bending stiffness matrices.
%   Q_bari is an array of transformed reduced stiffness matrices in the form Q_bari =
%   [Q_bar1 Q_bar2 ... Q_barNL], where NL is the number of laminae.
%   h is an array of the z-coordinates of each lamina.

% Find number of layers
NL = length(Q_bar1)/3;

% reshape Q_bar matrices
Q_bar1 = reshape(Q_bar1, [3,3,NL]); 
Q_bar2 = reshape(Q_bar2, [2,2,NL]);

% Initialize stiffness matrices
A1 = zeros(3); B1 = zeros(3); D1 = zeros(3); E1 = zeros(3); F1 = zeros(3); H1 = zeros(3);
A2 = zeros(2); D2 = zeros(2); F2 = zeros(2);

% Compute stiffness matrices (1,2,6)
for i=1:3
    for j=1:3
        for k=1:NL
            A1(i,j) = A1(i,j) + Q_bar1(i,j,k) * (z(k+1)-z(k));
            B1(i,j) = B1(i,j) + (1/2)*Q_bar1(i,j,k) * (z(k+1)^2-z(k)^2);
            D1(i,j) = D1(i,j) + (1/3)*Q_bar1(i,j,k) * (z(k+1)^3-z(k)^3);
            E1(i,j) = E1(i,j) + (1/4)*Q_bar1(i,j,k) * (z(k+1)^4-z(k)^4);
            F1(i,j) = F1(i,j) + (1/5)*Q_bar1(i,j,k) * (z(k+1)^5-z(k)^5);
            H1(i,j) = H1(i,j) + (1/7)*Q_bar1(i,j,k) * (z(k+1)^7-z(k)^7);
        end
    end
end

% Compute stiffness matrices (4,5)
for i=1:2
    for j=1:2
        for k=1:NL
            A2(i,j) = A2(i,j) + Q_bar2(i,j,k) * (z(k+1)-z(k));
            D2(i,j) = D2(i,j) + (1/3)*Q_bar2(i,j,k) * (z(k+1)^3-z(k)^3);
            F2(i,j) = F2(i,j) + (1/5)*Q_bar2(i,j,k) * (z(k+1)^5-z(k)^5);
        end
    end
end

end

