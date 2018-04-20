function [ ptrans ] = transform3d( alpha, beta, gamma, tx, ty, tz, p )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
ca = cos(alpha*pi/180);
sa = sin(alpha*pi/180);

cb = cos(beta*pi/180);
sb = sin(beta*pi/180);

cg = cos(gamma*pi/180);
sg = sin(gamma*pi/180);


T = [   ca*cb, ca*sb*sg - sa*cg, ca*sb*cg + sa*sg, tx;
        sa*cb, sa*sb*sg + ca*cg, sa*sb*cg - ca*sg, ty;
        -1*sb, cb*sg,            cb*cg,            tz;
        0,     0,                0,                 1];

[m,n] = size(p);

if (m == 3 && n == 1)
    ptrans = T * [p;1];
elseif (m == 4 && n == 1)
    ptrans = T * p;
elseif (m == 1 && n == 3)
    ptrans = T * [p,1]';
else
    ptrans = T * p';
end

ptrans = [ptrans(1), ptrans(2), ptrans(3)];

end

