function f = stickslipnaive(t,x)
%stickslip system with differential inclusion type of friction model
%naive method
%[tnaive,xnaive] = ode45('stickslipnaive',[0 11.3],[1.067 0],odeset('RelTol',1e-8,'AbsTol',1e-8));
k = 1;
m = 1;
Fs = 1;
vdr = 0.2;
delta= 3;
gamma_T = x(2) - vdr;

 F_T = -Fs/(1+delta*abs(gamma_T))*sign(gamma_T);
 f = [x(2);
      -k/m*x(1) + F_T/m]; 
      