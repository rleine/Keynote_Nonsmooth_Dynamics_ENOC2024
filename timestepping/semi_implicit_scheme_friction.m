function [t,q,u] = semi_implicit_scheme_friction(sys,t0,te,q0,u0,N,tol)
% Semi-implicit scheme for inelastic impacts with friction
t = linspace(t0,te,N); dt = (te-t0)/(N-1);         %time stamp and time step
q = zeros(sys.dim_q,N); u = zeros(sys.dim_q,N); 
PN = zeros(length(sys.I),1); PT = zeros(length(sys.I),1);  %memory allocation
q(:,1) = q0; u(:,1) = u0;                          %initial condition

for i=1:(N-1)
  h = sys.h(t(i),q(:,i),u(:,i));
  M = sys.M(t(i),q(:,i));
  [WN,WT,~,ChiT] = sys.WChi(t(i),q(:,i),sys.I);   
  mu = sys.mu;
  converged = false;  
  while ~converged                                 %fixed point iteration
      u(:,i+1) = u(:,i) + M\(h*dt + WN*PN + WT*PT);
      q(:,i+1) = q(:,i) + u(:,i+1)*dt; 
      gN = sys.gN(t(i+1),q(:,i+1),sys.I); 
      gammaT = WT'*u(:,i+1) + ChiT; 
      PNnew = proxCN(PN-sys.r/dt*gN);
      PTnew = proxCT(PT-sys.r*gammaT,mu.*PNnew);
      converged = norm(PN-PNnew) + norm(PT-PTnew)< tol;
      PN = PNnew; PT = PTnew;
  end 
  if ~converged, disp('not converged'), t(i), end
end

function y = proxCN(x), y = max(0,x);   %proximal point function for CN = R_0^+
function y = proxCT(x,a), y = max(-a,min(x,a));   %proximal point function for CT = [-a,a]