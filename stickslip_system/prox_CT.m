function [prox,dproxdz] = prox_CT(z,a)
% proximal point on CT = [-a, a], scalar input
    prox = max(-a,min(z,a));
    if abs(z) > a
     dproxdz = 0;
    else
     dproxdz = 1;
    end
end