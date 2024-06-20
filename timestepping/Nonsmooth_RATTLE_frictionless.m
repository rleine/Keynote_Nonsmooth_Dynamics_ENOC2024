function [t,q,u] = Nonsmooth_RATTLE_frictionless(sys,t0,te,q0,u0,N,tol)
% Nonsmooth RATTLE scheme for frictionless (partially) elastic impacts
t = linspace(t0,te,N); dt = (te-t0)/(N-1);         %time stamp and time step
q = zeros(sys.dim_q,N); u = zeros(sys.dim_q,N);    %memory allocation
PN1st = zeros(length(sys.I),1); PN = zeros(length(sys.I),1);  PNnew = PN; 
q(:,1) = q0; u(:,1) = u0;                          %initial condition

for i=1:(N-1)

  %stage 1  
  M = sys.M(t(i),q(:,i));
  [WN,~,ChiN] = sys.WChi(t(i),q(:,i),sys.I);
  u_half = u(:,i);
  converged = false;  
  while ~converged                                 %fixed point iteration
      h = sys.h(t(i),q(:,i),u_half);
      u_half = u(:,i) + M\(h*dt/2 + WN*PN1st);
      q(:,i+1) = q(:,i) + u_half*dt;   
      gN = sys.gN(t(i+1),q(:,i+1),sys.I);     
      PN1stnew = proxCN(PN1st-sys.r/dt*gN);
      converged = norm(PN1st-PN1stnew) < tol;
      PN1st = PN1stnew;
  end 
 
  A = find(PN1st-sys.r/dt*gN>=0);
  notA = setdiff(sys.I',A);
  PN(notA,1) = zeros(length(notA),1);
  PNnew = zeros(length(sys.I),1); 
  
  %stage 2  
  M = sys.M(t(i+1),q(:,i+1));
  h = sys.h(t(i+1),q(:,i+1),u_half);
  if ~isempty(A)
    gammaN_begin = WN'*u(:,i) + ChiN;  
    [WN,~,ChiN] = sys.WChi(t(i+1),q(:,i+1),sys.I);
    converged = false;  
    while ~converged                                 %fixed point iteration      
      PN2nd = PN - PN1st;
      u(:,i+1) = u_half + M\(h*dt/2 + WN*PN2nd);
      gammaN_end = WN'*u(:,i+1) + ChiN;
      xiN = gammaN_end + sys.eN.*gammaN_begin;     
      PNnew(A) = proxCN(PN(A)-sys.r*xiN(A));
      converged = norm(PN-PNnew) < tol;
      PN = PNnew;
    end    
  else
     u(:,i+1) = u_half + M\(h*dt/2); 
  end    
  
end

function y = proxCN(x), y = max(0,x);   %proximal point function for CN = R_0^+