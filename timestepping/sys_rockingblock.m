classdef sys_rockingblock < class_sys
%
% Rocking block system 
%

    properties
        m = 1;
        a = 0.0125;               
        b = 0.05;                 
        gravity = 9.81;
        J
        mu = [0.3;0.3];
        eN = [0;0];
        eT = [0;0];
    end

    methods

        function obj = sys_rockingblock
            obj.r = 1e-1;
            obj.dim_q = 3;
            obj.I = [1,2];
            obj.J = 1/12*obj.m*(4*obj.a^2+4*obj.b^2);
            obj.M_const = diag([obj.m,obj.m,obj.J]);
            obj.h_const = [ 0;
                           -obj.m*obj.gravity;
                            0];
        end    

  

        function [WN,WT,ChiN,ChiT] = WChi(obj,t,q,I)
            phi=q(3);
            WT(:,1) = [ 1; 0; obj.b*cos(phi)+obj.a*sin(phi)];
            WT(:,2) = [ 1; 0; obj.b*cos(phi)-obj.a*sin(phi)];
            WT(:,3) = [ 1; 0; -obj.b*cos(phi)+obj.a*sin(phi)];
            WT(:,4) = [ 1; 0; -obj.b*cos(phi)-obj.a*sin(phi)];

            WN(:,1) = [ 0; 1;-obj.a*cos(phi)+obj.b*sin(phi)];
            WN(:,2) = [ 0; 1; obj.a*cos(phi)+obj.b*sin(phi)];
            WN(:,3) = [ 0; 1;-obj.a*cos(phi)-obj.b*sin(phi)];
            WN(:,4) = [ 0; 1; obj.a*cos(phi)-obj.b*sin(phi)];
     
            WN = WN(:,I);
            WT = WT(:,I);
            ChiN = zeros(length(I),1);
            ChiT = zeros(length(I),1);
        end


        function [nuN,nuT] = nu(obj,t,q,u,I)
            phi=q(3);
            phidot = u(3);
    
            nuN = [(obj.a*sin(phi) + obj.b*cos(phi))*phidot^2;
                   (-obj.a*sin(phi) + obj.b*cos(phi))*phidot^2;
                   (obj.a*sin(phi) - obj.b*cos(phi))*phidot^2;
                   (-obj.a*sin(phi) - obj.b*cos(phi))*phidot^2];

            nuT = [(obj.a*cos(phi) - obj.b*sin(phi))*phidot^2;
                   (-obj.a*cos(phi) - obj.b*sin(phi))*phidot^2;
                   (obj.a*cos(phi) + obj.b*sin(phi))*phidot^2;
                   (-obj.a*cos(phi) + obj.b*sin(phi))*phidot^2];
           
            nuN = nuN(I);
            nuT = nuT(I);
        end

        function gN = gN(obj,t,q,I)
            phi = q(3);
            y = q(2);
            gN1 = y-obj.a*sin(phi)-obj.b*cos(phi);
            gN2 = y+obj.a*sin(phi)-obj.b*cos(phi);
            gN3 = y-obj.a*sin(phi)+obj.b*cos(phi);
            gN4 = y+obj.a*sin(phi)+obj.b*cos(phi);
            gN =[gN1;gN2;gN3;gN4];
            gN = gN(I);
        end    

    end

end

