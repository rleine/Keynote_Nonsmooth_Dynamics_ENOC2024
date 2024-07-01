classdef sys_three_ball_chain < class_sys
%
% three ball chain system 
%
% Remco Leine, University of Stuttgart, 2024

    properties
        m1 = 1;
        m2 = 1;
        m3 = 1;
        R = 1;
        eN = [1;1];
        eT = [];
    end

    methods

        function obj = sys_three_ball_chain
            obj.r = 1e-1;
            obj.dim_q = 3;
            obj.I = [1,2];
            obj.M_const = diag([obj.m1,obj.m2,obj.m3]);
            obj.h_const = [ 0;0;0];
        end    

        function [WN,WT,ChiN,ChiT] = WChi(obj,t,q,I)
            WN(:,1) = [ -1; 1;-0];
            WN(:,2) = [ 0; -1; 1];
            
            WN = WN(:,I);
     
            ChiN = zeros(length(I),1);
            WT = [];
            ChiT = [];
        end


      
        function gN = gN(obj,t,q,I)          
            gN1 = q(2)-q(1)-2*obj.R;         
            gN2 = q(3)-q(2)-2*obj.R;           
            gN =[gN1;gN2];
            gN = gN(I);
        end    

        function [q,u,gN] = exact(obj,t,q0,u0)
            t_imp = -q0(1)/u0(1);
            q_imp = [0;2*obj.R;4*obj.R];
            WN = obj.WChi([],[],obj.I);
            M = obj.M_const;
            G = WN'*(M\WN);
            u_min = u0;
            gammaN_min = WN'*u_min;
            LambdaN = -G\(eye(2) + diag(obj.eN))*gammaN_min;
            u_plus = u_min  + M\(WN*LambdaN);
            for i=1:length(t)
                if t(i)<t_imp
                    q(:,i) = q0 + u_min*t(i);
                    u(:,i) = u0;
                else
                    q(:,i) = q_imp + u_plus*(t(i)-t_imp);
                    u(:,i) = u_plus;
                end    
            end  
            gN = obj.getgNall(t,q);
        end    

    end

end

