function [ z ] = computecoords( layerthicknesses )
%computecoords Converts laminate layer thicknesses to vertical coordinates.
%   Detailed explanation goes here

n = length(layerthicknesses);
h = sum(layerthicknesses);

z = zeros(1,n+1);
z(1) = -h/2; z(end) = h/2; % top and bottom surfaces
for i=2:n
    z(i) = z(i-1) + layerthicknesses(i-1);
end

end

