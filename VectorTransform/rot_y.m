function [ proty ] = rot_y( beta, p )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
cb = cos(beta*pi/180);
sb = sin(beta*pi/180);

Ry = [   cb, 0, sb;
          0, 1, 0;
      -1*sb, 0, cb];

[m,n] = size(p);

if (m == 3 && n == 1)
    proty = Ry * p;
else
    proty = Ry * p';
end

end

