function [t,x] = dae_semi_implicit_euler(sys,t_span,x0,N,tol,max_iter)
% Semi-implicit Euler scheme for DAE's of index 1 or index 2 
% dx/dt = f(t,x,lambda)
% 0  = c(x,lambda)

t0 = t_span(1);
te = t_span(2);

t = linspace(t0,te,N);
dt = t(2)-t(1);
x = zeros(sys.dim_x,N);
x(:,1) = x0; 
lambda = zeros(sys.dim_lambda,1);

for i=1:N-1
    lambda = newton(@(lambda) c_red(lambda),lambda,tol,max_iter);
    x(:,i+1) = x(:,i) + dt*sys.f_fun(t(i),x(:,i),lambda);
end
x = x'; %to be compatible with the output of odefun

    function [cr,dcrdlambda] = c_red(lambda)
        x_ip1 = x(:,i) + dt*sys.f_fun(t(i),x(:,i),lambda);
        [cr,dcdx,dcdlambda] = sys.c_fun_deriv(x_ip1,lambda);
        dcrdlambda = dt*dcdx*sys.dfdlambda(t(i),x(:,i),lambda) + dcdlambda; 
    end

end


