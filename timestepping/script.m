%script to make figures for the presentation 
% Leine - Nonsmooth dynamics- Keynote ENOC 2024 Delft

%%  Woodpecker Toy
q0 = [0;-0.000107;0.00312], u0 = [-0.3505;31.81;14.44]
[t,q,u] = woodpeckertimestepping(0,0.15,q0,u0,1000);
figure(5)
plot(t,q,'o-')


%% Rocking block
sys = sys_rockingblock;
phi0 = 14/180*pi;
q0 = [0;0.1+sys.a*sin(phi0)+sys.b*cos(phi0);phi0];       
u0 = [0.1;0;0];
[t,q,u] = semi_implicit_scheme(sys,0,0.8,q0,u0,2000,1e-4);
figure(1)
gN = sys.getgNall(t,q);
plot(t,gN,'o-')

sys = sys_funnel(16);
n = sys.n;
col = 4;
row = ceil(n/col);
for i = 1:row
    x0((i-1)*col+1:i*col) = [ 0 1 2 3]*2*sys.R*1.05;
    y0((i-1)*col+1:i*col) = i*[1 1 1 1]*2*sys.R*1.05;
end
x0 = x0(1:n); x0 = x0(:);
x0 = x0 - mean(x0)+1;
y0 = y0(1:n)+10; y0 = y0(:);
q0 = [x0;y0];
u0 = zeros(sys.dim_q,1);
[t,q,u] = semi_implicit_scheme(sys,0,10,q0,u0,1000,1e-7);
figure(2)
gN = sys.getgNall(t,q);
plot(t,gN,'o-')



sys = sys_rockingblock;
phi0 = 10/180*pi;
q0 = [0;sys.a*sin(phi0)+sys.b*cos(phi0);phi0];       
u0 = [0;0;0];
[t,q,u] = semi_implicit_scheme_friction(sys,0,2,q0,u0,2000,1e-4);
figure(4)
gN = sys.getgNall(t,q);
plot(t,gN,'o-')

sys = sys_3ballchain;
q0 = [-0.2;2*sys.R;4*sys.R];       
u0 = [1;0;0];

t_exact = linspace(0,2,2000);
[q_exact,u_exact,gN_exact] = sys.exact(t_exact,q0,u0);

[t,q,u] = semi_implicit_scheme_elastic(sys,0,2,q0,u0,2000,1e-5);
figure(5)
gN = sys.getgNall(t,q);
plot(t,gN,'o-',t_exact,gN_exact,'k')
xlabel('t')
ylabel('gN')
title(['Semi-implicit scheme, timestep = ',num2str(t(2)-t(1))])

[t,q,u] = Nonsmooth_RATTLE_frictionless(sys,0,2,q0,u0,2000,1e-5);
figure(6)
gN = sys.getgNall(t,q);
plot(t,gN,'o-',t_exact,gN_exact,'k')
xlabel('t')
ylabel('gN')
title(['Nonsmooth RATTLE, timestep = ',num2str(t(2)-t(1))])

