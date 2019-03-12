clear; clc;

%% Find steady state model
b = [11.88, 4.977, 539.6, 129.9, 5625];
a = [1, 1.169, 50.3, 45.94, 685.3, 391.7, 1952];

[A, B, C, D] = tf2ss(b,a);
sys = ss(A,B,C,D);
sys.u = 'u';
sys.y = 'y';

%% Get relative order
r = 6 - 4;

%% Find inverse model
K_y = (C*A^r) / (C*A^(r-1)*B);
B_y = 1 / (C*A^(r-1)*B);

A_inv = A - B*K_y;
B_inv = B*B_y;
C_inv = -K_y;
D_inv = B_y;

sys_inv = ss(A_inv,B_inv,C_inv,D_inv);
sys_inv.u = 'y_d_r';
sys_inv.y = 'u_ff';

%% Add error
e = -0.05;
b_err = b;
b_err(end) = b_err(end)*(1+e);

sys_err = tf(b_err,a);
sys_err.u = 'u';
sys_err.y = 'y';

%% Pid controller
Kp = 30.42;
Ki = 69.08;
Kd = 3.349;
sys_pid = pid(Kp,Ki,Kd);
sys_pid.u = 'e';
sys_pid.y = 'u_fb';

%% Find y_d
t_range = [0, 10];
t = linspace(t_range(1),t_range(2),1000 + 1);
opts = odeset('RelTol',1e-13,'AbsTol',1e-15);
[t, y_d] = ode45(@(t,y) findy(t,y),t,[0, 0],opts);
y_d_r = arrayfun(@(x) dy2(x),t);

%% Simulate
% sim('simulation_ff.slx');
% sim('simulation_fb.slx');
% sim('simulation_ff_fb.slx');

%% Feedforward Control only
uff = lsim(sys_inv,y_d_r,t);
y_ff = lsim(sys_err,uff,t);

%% Feedback Control only
sys_fb = feedback(sys_pid*sys_err,1);
y_fb = lsim(sys_fb,y_d(:,1),t);

%% Feedforwd + Feedback
sum_u = sumblk('u = u_ff + u_fb');
sum_e = sumblk('e = y_d - y');
sys_ff_fb = connect(sys_pid,sys_err,sum_u,sum_e,{'y_d','u_ff'},'y');
y_ff_fb = lsim(sys_ff_fb,[y_d(:,1),uff],t);

%% Plot
figure();
plot_result(y_ff,t,y_d,y_d_r,uff);
figure();
plot_result(y_fb,t,y_d,y_d_r);
figure();
plot_result(y_ff_fb,t,y_d,y_d_r,uff);