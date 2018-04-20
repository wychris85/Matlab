
px=1;
py=-2;
pz=4;

tx=0;
ty=0;
tz=0;

alpha=90;
beta=0;
gamma=0;

%%
% (1) m=1, n=3
p = [px, py, pz];
ptrans1 = transform3D(gamma, beta, alpha, tx, ty, tz, p);
protx1 = rot_x(alpha, p);
proty1 = rot_y(beta, p);
protz1 = rot_z(gamma, p);

%%
% (2) m=1, n=4
p = [px, py, pz, 1];
ptrans2 = transform3D(gamma, beta, alpha, tx, ty, tz, p);
protx2 = rot_x(alpha, p(1:end-1));
proty2 = rot_y(beta, p(1:end-1));
protz2 = rot_z(gamma, p(1:end-1));

%%
% (3) m=3, n=1
p = [px, py, pz]';
ptrans3 = transform3D(gamma, beta, alpha, tx, ty, tz, p);
protx3 = rot_x(alpha, p);
proty3 = rot_y(beta, p);
protz3 = rot_z(gamma, p);

%%
% (4) m=4, n=1
p = [px, py, pz, 1]';
ptrans4 = transform3D(gamma, beta, alpha, tx, ty, tz, p);
protx4 = rot_x(alpha, p(1:end-1));
proty4 = rot_y(beta, p(1:end-1));
protz4 = rot_z(gamma, p(1:end-1));

