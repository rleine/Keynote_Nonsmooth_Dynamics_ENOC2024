function f = block_on_belt_arctangent_regularization(t,x,epsilon)
% block-on-belt system with arctangent regularization of the friction law
%
% [t,x] = ode45('block_on_belt_arctangent_regularization',[0 11.3],[1.067 0],odeset('RelTol',1e-8,'AbsTol',1e-8));
%
% Remco Leine, University of Stuttgart, 2024
if nargin<3, epsilon = 1e3; end
k = 1;
m = 1;
Fs = 1;
vdr = 0.2;
delta= 3;
gamma_T = x(2) - vdr;

F_T = -Fs/(1+delta*abs(gamma_T))*2/pi*atan(epsilon*gamma_T);

f = [x(2);
     -k/m*x(1) + F_T/m]; 
      