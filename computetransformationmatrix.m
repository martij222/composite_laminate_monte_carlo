function [ T ] = computetransformationmatrix( theta )
%computetransformationmatrix Computes the transformation matrix for use in
%computing local stresses and/or strains.
%   From Kaw, Eq. 2.96 p111

theta = theta * (pi/180);
c = cos(theta); s = sin(theta);

T = [c^2 s^2 2*s*c; ...
     s^2 c^2 -2*s*c; ...
     -s*c s*c c^2 - s^2;];

end

