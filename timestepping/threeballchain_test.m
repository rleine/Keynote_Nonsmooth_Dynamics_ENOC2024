%% 3-ball chain test

sys = sys_3ballchain;
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
title(['Semi-implicit scheme, timestep = ',num2str(t1(2)-t1(1))])

[t2,q2,u2] = semi_implicit_scheme_elastic(sys,0,2,q0,u0,2001,1e-5);
figure(4)
gN2 = sys.getgNall(t2,q2);
plot(t2,gN2,'o-',t_exact,gN_exact,'k')
xlabel('t')
ylabel('gN')
title(['Semi-implicit scheme, timestep = ',num2str(t2(2)-t2(1))])

% make animation
two3ballchain_anim(sys,t1,q1,t2,q2,'threeballchain');

%% Nonsmooth RATTLE scheme
% optionally, one can check with that the Nonsmooth RATTLE scheme gives 
% the correct result (not used in the presentation)

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

