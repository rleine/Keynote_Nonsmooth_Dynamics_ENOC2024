classdef class_sys
% base class of a mechanical system with frictional unilateral constraints

    properties
     M_const
     h_const
     WN
     WT
     I
     dim_q
     r
    end

    methods
       
        function M = M(obj,~,~)
             M = obj.M_const;
        end

        function h = h(obj,~,~,~)
            h = obj.h_const;
        end

        function [WN,WT,ChiN,ChiT] = WChi(obj,~,~,I)
            WN = obj.WN(:,I);
            WT = obj.WT(:,I);
            ChiN = zeros(length(I),1);
            ChiT = zeros(length(I),1);
        end

        function [nuN,nuT] = nu(obj,~,~,~,I)
            nuN = zeros(length(I),1);
            nuT = zeros(length(I),1);
        end

        function [mu,eN,eT] = contactpar(obj,I)
            mu = obj.mu(I);
            eN = obj.eN(I);
            eT = obj.eT(I);
        end    

        function gN = gN(obj,t,q,I)
 
        end    

        function gNall = getgNall(obj,t,q)
            gNall = zeros(length(obj.I),length(t));
            for i=1:length(t)
                 gNall(:,i) = obj.gN(t(i),q(:,i),obj.I);
            end     
        end    
    end

end

