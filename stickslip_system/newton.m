function [x,f,dfdx,conv,k] = newton(fun,x0,tol,maxiter)
% Newton's method to find zeros
% Remco Leine, INM, University of Stuttgart, 2023
x = x0;
k=0;
conv = 0;
while ~conv & k<maxiter
    [f,dfdx] = feval(fun,x);
    if norm(f)<tol
        conv = 1;
    else    
        k = k+1;
        x = x - dfdx\f;
    end
end

