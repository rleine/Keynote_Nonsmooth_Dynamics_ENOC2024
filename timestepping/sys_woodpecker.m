classdef sys_woodpecker < class_sys
% Woodpecker system 
%
% see Section 5.3.5 "Spielzeugspecht" of 
% Glocker, Ch., Dynamik von Starrkörpersystemen mit Reibung und Stössen, 1995.
%

    properties
        mM = 0.0003;
        JM = 5.0e-9;
        mS = 0.0045;
        JS = 7.0e-7;
        lM = 0.010;
        lG = 0.015;
        lS = 0.0201;
        rM = 0.0031;
        r0 = 0.0025;
        hM = 0.0058;
        hS = 0.02;
        gravity = 9.81;
        cphi = 0.0056;
        mu = [0.3;0.3;0.3];
        eN = [0.5;0;0];
        eT = [0;0;0];
    end

    methods

        function obj = sys_woodpecker
            obj.r = 1e-3;
            obj.dim_q = 3;
            obj.I = [1,2,3];
            obj.WN(:,1) = [ 0; 0;-obj.hS];
            obj.WN(:,2) = [ 0; obj.hM; 0];
            obj.WN(:,3) = [ 0;-obj.hM; 0];
            obj.WT(:,1) = [ 1; obj.lM; obj.lG-obj.lS];
            obj.WT(:,2) = [ 1; obj.rM; 0];
            obj.WT(:,3) = [ 1; obj.rM; 0];
            obj.M_const =[(obj.mS+obj.mM) obj.mS*obj.lM            obj.mS*obj.lG      ;
                           obj.mS*obj.lM  (obj.JM+obj.mS*obj.lM^2) obj.mS*obj.lM*obj.lG   ;
                           obj.mS*obj.lG  obj.mS*obj.lM*obj.lG     (obj.JS+obj.mS*obj.lG^2)];
        end    


        function h = h(obj,t,q,u)
            phiM = q(2);
            phiS = q(3);
            h = [ -(obj.mS+obj.mM)*obj.gravity;
                 -obj.cphi*(phiM-phiS)-obj.mS*obj.gravity*obj.lM;
                 -obj.cphi*(phiS-phiM)-obj.mS*obj.gravity*obj.lG];
        end

        function gN = gN(obj,t,q,I)
            phiM = q(2);
            phiS = q(3);
            gN1 = (obj.lM+obj.lG-obj.lS-obj.r0) - obj.hS*phiS;
            gN2 = (obj.rM-obj.r0) + obj.hM*phiM;
            gN3 = (obj.rM-obj.r0) - obj.hM*phiM;
            gN = [gN1;gN2;gN3];
            gN = gN(I);
        end    

    end

end


