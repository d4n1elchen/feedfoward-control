clear; clc;

b = [11.88, 4.977, 539.6, 129.9, 5625];
a = [1, 1.169, 50.3, 45.94, 685.3, 391.7, 1952];

[A, B, C, D] = tf2ss(b, a);

r = 6 - 4;

K_y = (C*A^r) / (C*A^(r-1)*B);
B_y = 1 / (C*A^(r-1)*B);

A_inv = A - B*K_y;
B_inv = B*B_y;
C_inv = -K_y;
D_inv = B_y;