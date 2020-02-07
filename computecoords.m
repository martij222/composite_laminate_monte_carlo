function [ z ] = computecoords( layerthicknesses )
%computecoords Converts laminate layer thicknesses to vertical coordinates.
%   Detailed explanation goes here

n = length(layerthicknesses);
h = sum(layerthicknesses);

z = zeros(1,n+1);
for i=1:(n+1)
    if i==1
        z(i) = -h/2;
    elseif i>1 & i<(n+1)
        z(i) = z(i-1) + layerthicknesses(i-1);
    else
        z(i) = h/2;
    end
end

end

