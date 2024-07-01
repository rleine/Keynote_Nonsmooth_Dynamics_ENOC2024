classdef class_block_on_belt
% Single DOF model of a block on a conveyor belt suspended by a spring and a
% dashpot, with dry friction with Stribeck
    properties
        k = 1;
        m = 1;
        Fs = 1;
        vdr = 0.2;
        delta = 3;
        c = 0;
        r = 1;
        dim_x = 2;
        dim_lambda = 1;
    end

    methods

        function f_out = f_fun(obj,t,x,lambda)
            q = x(1);
            u = x(2);
            gammaT = u - obj.vdr;
            FD = obj.Fs*obj.delta*gammaT/(1+obj.delta*abs(gammaT));
            lambdaT = lambda;
            f_out  = [x(2); obj.m\(-obj.c*u - obj.k*q + FD + lambdaT)];
        end

        function out = dfdlambda(obj,t,x,lambda)
            out  = [ 0
                     1/obj.m];
        end

        function [c_fun,dcdx,dcdlambda] = c_fun_deriv(obj,x,lambda)
            gammaT = x(2)-obj.vdr;
            [prox,dproxdz] = prox_CT(-lambda + obj.r*gammaT,obj.Fs);
            c_fun  = lambda  + prox;
            dcdx = dproxdz*[0 obj.r];
            dcdlambda = 1 - dproxdz;
        end

    end
end


