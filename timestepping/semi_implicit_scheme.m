function [t,q,u] = semi_implicit_scheme(sys,t0,te,q0,u0,N,tol)
% Semi-implicit scheme for frictionless inelastic impacts
t = linspace(t0,te,N); dt = (te-t0)/(N-1);         %time stamp and time step
q = zeros(sys.dim_q,N); u = zeros(sys.dim_q,N); PN = zeros(length(sys.I),1);   %memory allocation
q(:,1) = q0; u(:,1) = u0;                          %initial condition

for i=1:(N-1)
  h = sys.h(t(i),q(:,i),u(:,i));
  M = sys.M(t(i),q(:,i));
  WN = sys.WChi(t(i),q(:,i),sys.I);    
  converged = false;  
  while ~converged                                 %fixed point iteration
      u(:,i+1) = u(:,i) + M\(h*dt + WN*PN);
      q(:,i+1) = q(:,i) + u(:,i+1)*dt; 
      gN = sys.gN(t(i+1),q(:,i+1),sys.I);    
      PNnew = proxCN(PN-sys.r/dt*gN);
      converged = norm(PN-PNnew) < tol;
      PN = PNnew;
  end 
end

function y = proxCN(x), y = max(0,x);   %proximal point function for CN = R_0^+