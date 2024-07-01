% Leine - Nonsmooth dynamics- Keynote ENOC 2024 Delft
%
% script to make figures and some videos of timestepping methods
% using in the keynote lecture
%
% Remco Leine, University of Stuttgart, 2024

%%  Woodpecker Toy (slide 22)
%
% see Section 5.3.5 "Spielzeugspecht" of 
% Glocker, Ch., Dynamik von Starrkörpersystemen mit Reibung und Stössen, 1995.
%
q0 = [0;-0.000107;0.00312], u0 = [-0.3505;31.81;14.44]
[t,q,u] = woodpeckertimestepping(0,0.15,q0,u0,1000);
figure(1)
plot(t,q,'o-')
xlabel('t')
ylabel('y,phiS, phiM')
title('The woodpecker system')

% The animation of the woodpecker system in the presentation has been made 
% with Blender (not provided)


%% Funnel with 16 balls (slide 26)
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
xlabel('t')
ylabel('gN')
title('Funnel with 16 balls, contact distance')

% make animation
funnel_anim(sys,t,q,'funnel.avi')

%% Three-ball chain (slide 27)


sys = sys_three_ball_chain;
q0 = [-0.9;2*sys.R;4*sys.R];       
u0 = [1;0;0];

t_exact = linspace(0,2,2000);
[q_exact,u_exact,gN_exact] = sys.exact(t_exact,q0,u0);

[t1,q1,u1] = semi_implicit_scheme_elastic(sys,0,2,q0,u0,2000,1e-5);
figure(3)
gN1 = sys.getgNall(t1,q1);
plot(t1,gN1,'o-',t_exact,gN_exact,'k')
xlabel('t')
ylabel('gN')
title(['Three-ball chain, semi-implicit scheme, timestep = ',num2str(t1(2)-t1(1))])

[t2,q2,u2] = semi_implicit_scheme_elastic(sys,0,2,q0,u0,2001,1e-5);
figure(4)
gN2 = sys.getgNall(t2,q2);
plot(t2,gN2,'o-',t_exact,gN_exact,'k')
xlabel('t')
ylabel('gN')
title(['Three-ball chain, semi-implicit scheme, timestep = ',num2str(t2(2)-t2(1))])

% make animation
three_ball_chain_anim(sys,t1,q1,t2,q2,'three_ball_chain');

%% Nonsmooth RATTLE scheme
% optionally, one can check with that the Nonsmooth RATTLE scheme gives 
% the correct result for the three ball chain system (not used in the presentation)

[t,q,u] = Nonsmooth_RATTLE_frictionless(sys,0,2,q0,u0,2000,1e-5);
figure(5)
gN = sys.getgNall(t,q);
plot(t,gN,'o-',t_exact,gN_exact,'k')
xlabel('t')
ylabel('gN')
title(['Nonsmooth RATTLE, timestep = ',num2str(t(2)-t(1))])

[t,q,u] = Nonsmooth_RATTLE_frictionless(sys,0,2,q0,u0,2001,1e-5);
figure(6)
gN = sys.getgNall(t,q);
plot(t,gN,'o-',t_exact,gN_exact,'k')
xlabel('t')
ylabel('gN')
title(['Nonsmooth RATTLE, timestep = ',num2str(t(2)-t(1))])

% The code for the Nonsmooth RATTLE scheme (slide 31) is given in 
% Nonsmooth_RATTLE_frictionless.m

% The simulations on slides 31, 32 and 33 are not provided

