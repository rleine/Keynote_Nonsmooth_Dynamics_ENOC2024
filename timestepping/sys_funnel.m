classdef sys_funnel < class_sys
%
% Funnel system 
%

    properties
        n
        x_left
        y_left
        x_right
        y_right
        m = 1;
        R = 1;
        R0 = 10;
        a = 1.2;  
        gravity = 9.81;
        mu;
        eN;
        eT;
    end

    methods

        function obj = sys_funnel(n)
            obj.n = n;
            obj.r = 1e-1;
            obj.dim_q = 2*obj.n ;
            obj.I = 1:(n*2 + n*(n-1)/2);
            
            obj.x_left = -(obj.R0+ obj.a);
            obj.y_left = 0;
            obj.x_right = (obj.R0+ obj.a);
            obj.y_right = 0;

            obj.M_const = eye(obj.dim_q )*obj.m;
            obj.h_const = [ zeros(n,1);
                           -ones(n,1)*obj.m*obj.gravity];
            obj.mu = zeros(length(obj.I),1);
            obj.eN = zeros(length(obj.I),1);
            obj.eT = zeros(length(obj.I),1);
 
        end    

        function [WN,WT,ChiN,ChiT] = WChi(obj,t,q,I)
            x = q(1:obj.n);
            y = q(obj.n+1:end);
  

            WN_left = [diag((x-obj.x_left)./sqrt((x-obj.x_left).^2 + (y-obj.y_left).^2))  ;
                       diag((y-obj.y_left)./sqrt((x-obj.x_left).^2 + (y-obj.y_left).^2)) ];

      
            WN_right = [diag((x-obj.x_right)./sqrt((x-obj.x_right).^2 + (y-obj.y_right).^2));
                        diag((y-obj.y_right)./sqrt((x-obj.x_right).^2 + (y-obj.y_right).^2))];
                
            WN_inter = zeros(obj.dim_q,obj.n*(obj.n -1)/2);
            k = 1;
            for i=1:(obj.n-1)
                for j=i+1:obj.n
                    WN_inter(i,k) = (x(i)-x(j))/sqrt((x(i)-x(j))^2 + (y(i)-y(j))^2);
                    WN_inter(j,k) = -WN_inter(i,k);
                    WN_inter(obj.n+i,k) = (y(i)-y(j))/sqrt((x(i)-x(j))^2 + (y(i)-y(j))^2);
                    WN_inter(obj.n+j,k) = -WN_inter(obj.n+i,k);
                    k = k+1;
                end
            end
  
            WN = [WN_left WN_right WN_inter];

            WT = 0*WN;

            WN = WN(:,I);
            WT = WT(:,I);
            ChiN = zeros(length(I),1);
            ChiT = zeros(length(I),1);
        end


   
        function gN = gN(obj,t,q,I)
            x = q(1:obj.n);
            y = q(obj.n+1:end);
   
            gN_left = sqrt((x-obj.x_left).^2 + (y-obj.y_left).^2) - obj.R - obj.R0;
            gN_right = sqrt((x-obj.x_right).^2 + (y-obj.y_right).^2) - obj.R - obj.R0;
         
            gN_inter = zeros(obj.n*(obj.n -1)/2,1);
            k = 1;
            for i=1:(obj.n-1)
                for j=i+1:obj.n
                    gN_inter(k) = sqrt((x(i)-x(j))^2 + (y(i)-y(j))^2) - 2*obj.R;
                    k = k+1;
                end
            end

            gN =[gN_left;gN_right;gN_inter];
            gN = gN(I);
        end    

    end

end

