function f = stickslipLuGre(t,x)
%stickslip system with differential inclusion type of friction model
%LuGre

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
      