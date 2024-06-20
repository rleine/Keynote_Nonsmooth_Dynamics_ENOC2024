% Leine - Nonsmooth dynamics- Keynote ENOC 2024 Delft
%
% script to make figures a comparison of time integration methods
% for the block on belt system with stick-slip motion
%
% Remco Leine, 2024

ax = [-0.7 1.2 -0.9 0.3];

% quasi-exact solution by taking a small timestep
sys = class_block_on_belt;
x0 = [1.135 0]';
[t_exact,x_exact] = dae_semi_implicit_euler(sys,[0 12.3],x0,5000,1e-7,1000);


% smoothing method using arctangent function

[t_smoothing,x_smoothing] = ode45(@(t,x) stickslipsmooth(t,x,1e3),[0 11.3],[1.067; 0],odeset('RelTol',1e-5,'AbsTol',1e-5));
figure(1)
plot(x_smoothing(:,1),x_smoothing(:,2),'o-',x_exact(:,1),x_exact(:,2),'k')
axis(ax)
xlabel('q')
ylabel('qdot')
disp(['arctangent smoothing method, number of time steps = ',num2str(length(t_smoothing))])


% LuGre model
x0 = [1.043656607367126   0.081148750297240  -0.007831711872955]';
[t_LuGre,x_LuGre] = ode45('stickslipLuGre',[0 11.05],x0,odeset('RelTol',1e-5,'AbsTol',1e-5));
figure(2)
plot(x_LuGre(:,1),x_LuGre(:,2),'o-',x_exact(:,1),x_exact(:,2),'k')
axis(ax)
xlabel('q')
ylabel('qdot')
disp(['LuGre method, number of time steps = ',num2str(length(t_LuGre))])

% Semi-implicit scheme
sys = class_block_on_belt;
x0 = [1.141 0]';
[t_dae,x_dae] = dae_semi_implicit_euler(sys,[0 12.3],x0,500,1e-7,1000);
figure(3)
plot(x_dae(:,1),x_dae(:,2),'o-',x_exact(:,1),x_exact(:,2),'k',x_LuGre(:,1),x_LuGre(:,2),'r-',x_smoothing(:,1),x_smoothing(:,2),'b-')
axis(ax)
xlabel('q')
ylabel('qdot')
disp(['semi implicit method, number of time steps = ',num2str(length(t_dae))])



