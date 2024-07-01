function f = block_on_belt_LuGre_regularization(t,x)
% block-on-belt system with LuGre regularization of the friction law
%
% [t,x] = ode45('block_on_belt_LuGre_regularization',[0 11.3],[1.067 0],odeset('RelTol',1e-8,'AbsTol',1e-8));
%
% Remco Leine, University of Stuttgart, 2024

k = 1;
m = 1;
Fs = 1;
vdr = 0.2;
delta= 3;
gamma_T = x(2) - vdr;

sigma_0 = 100;
sigma_1 = 20;

v = gamma_T;
g = Fs/(1+delta*abs(v));
z = x(3);
zdot = v -sigma_0*abs(v)/g*z;
F_T = -(sigma_0*z + sigma_1*zdot);

f = [x(2);
     -k/m*x(1) + F_T/m;
     zdot]; 
      