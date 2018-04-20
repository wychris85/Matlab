function [ protx ] = rot_x( alpha, p )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
ca = cos(alpha*pi/180);
sa = sin(alpha*pi/180);

Rx = [   1, 0, 0;
         0, ca, -1*sa;
         0, sa, ca];

[m,n] = size(p);

if (m == 3 && n == 1)
    protx = Rx * p;
else
    protx = Rx * p';
end

end

