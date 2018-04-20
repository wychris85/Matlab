function [ protz ] = rot_z( gamma, p )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
cg = cos(gamma*pi/180);
sg = sin(gamma*pi/180);

Rz = [   cg, -1*sg, 0;
         sg,    cg, 0;
          0,     0, 1];

[m,n] = size(p);

if (m == 3 && n == 1)
    protz = Rz * p;
else
    protz = Rz * p';
end

end

