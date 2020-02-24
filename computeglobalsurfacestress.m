function [ plystress ] = computeglobalsurfacestress( Qbar, global_strain )
%computeglobalsurfacestress Compute global stress at the top and bottom surface
%of a ply.
%   Detailed explanation goes here

plystress = zeros([3 1 2]);
plystress(:,:,1) = Qbar * global_strain(:,:,1); % top surface
plystress(:,:,2) = Qbar * global_strain(:,:,2); % bottom surface

end