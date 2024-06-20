function [t,q,u] = woodpeckertimestepping(t0,te,q0,u0,N)
mM = 3e-4; JM = 5e-9; mS = 4.5e-3; JS = 7e-7; lM = 0.01; lG = 0.015; lS = 0.0201;   %system 
rM = 0.0031; r0 = 0.0025; hM = 0.0058; hS = 0.02; grav = 9.81; cphi = 0.0056;       %parameters
mu = 0.3; eN = [0.5;0;0]; r = 1e-4; tol = 1e-8;
M =[(mS+mM) mS*lM mS*lG; mS*lM (JM+mS*lM^2) mS*lM*lG; mS*lG mS*lM*lG (JS+mS*lG^2)]; %constant 
WN = [0 0 0; 0 hM -hM; -hS 0 0]; WT = [1 1 1; lM rM rM; lG-lS  0 0];                %matrices

t = linspace(t0,te,N); dt = (te-t0)/(N-1);                                          %time stamp and time step
q = [q0 zeros(3,N-1)]; u = [u0 zeros(3,N-1)]; PN = zeros(3,1); PT = zeros(3,1);     %memory allocation

for i=1:(N-1)
  tM = t(i)+dt/2; qM = q(:,i) + dt/2*u(:,i);      %midpoint
  h = [-(mS+mM)*grav; -cphi*(qM(2)-qM(3))-mS*grav*lM; -cphi*(qM(3)-qM(2))-mS*grav*lG];
  gN = [lM+lG-lS-r0-hS*qM(3);rM-r0+hM*qM(2);rM-r0-hM*qM(2)];
  I = find(gN<=0)';  %index set of closed contacts
  if ~isempty(I)
    gammaNA = WN(:,I)'*u(:,i);  
    converged = false;  
    while ~converged %fixed point iteration
      u(:,i+1) = u(:,i)  + M\(h*dt + WN(:,I)*PN(I) + WT(:,I)*PT(I));
      gammaNE = WN(:,I)'*u(:,i+1); gammaTE = WT(:,I)'*u(:,i+1);    
      PNnew = proxCN(PN(I)-r*(gammaNE + eN(I).*gammaNA));
      PTnew = proxCT(PT(I)-r*gammaTE,mu*PN(I));
      converged = norm(PN(I)-PNnew)+norm(PT(I)-PTnew) < tol;
      PN(I) = PNnew; PT(I) = PTnew;
    end 
  else  %if all contacts are open
    u(:,i+1) = u(:,i) + M\(h*dt);
  end
  q(:,i+1) = qM + u(:,i+1)*dt/2; %end timestep
end

function y = proxCN(x), y = max(0,x);            %proximal point function for CN = R_0^+
function y = proxCT(x,a), y = max(min(x,a),-a);  %proximal point function for CT = [-a,a]