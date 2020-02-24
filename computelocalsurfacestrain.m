function [ plystrain ] = computelocalsurfacestrain( T, global_strain )
%computelocalsurfacestrain Compute local strain at the top and bottom surface
%of a ply.
%   Detailed explanation goes here

R = [1 0 0; 0 1 0; 0 0 2]; % Reuter matrix
plystrain = zeros([3 1 2]);
plystrain(:,:,1) = R*T*(R\global_strain(:,:,1)); % top surface
plystrain(:,:,2) = R*T*(R\global_strain(:,:,2)); % bottom surface

end