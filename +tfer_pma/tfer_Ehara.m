
% TFER_EHARA    Evaluates the transfer function for a PMA in Case A as per Ehara et al. (1996).
% Author:       Timothy Sipkens, 2018-12-27
%=========================================================================%

function [Lambda,sp] = tfer_Ehara(m_star,m,d,z,prop,varargin)
%-------------------------------------------------------------------------%
% Inputs:
%   m_star      Setpoint particle mass
%   m           Particle mass
%   d           Particle mobility diameter
%   z           Integer charge state
%   prop        Device properties (e.g. classifier length)
%   varargin    Name-value pairs for setpoint    (Optional, default Rm = 3)
%                   ('Rm',double) - Resolution
%                   ('omega1',double) - Angular speed of inner electrode
%                   ('V',double) - Setpoint voltage
%
% Outputs:
%   Lambda      Transfer function
%   G0          Function mapping final to initial radial position
%-------------------------------------------------------------------------%


[sp,tau,C0] = ...
    tfer_pma.get_setpoint(m_star,m,d,z,prop,varargin{:});
        % get setpoint (parses d and z)

%-- Estimate equilibrium radius ------------------------------------------%
if round((sqrt(C0./m_star)-sqrt(C0./m_star-4*sp.alpha*sp.beta))/(2*sp.alpha),15)==prop.rc
    rs = real((sqrt(C0./m)-...
        sqrt(C0./m-4*sp.alpha*sp.beta))./(2*sp.alpha));
        % equiblirium radius for a given mass
else
    rs = real((sqrt(C0./m)+...
        sqrt(C0./m-4*sp.alpha*sp.beta))./(2*sp.alpha));
        % equiblirium radius for a given mass
end


%-- Estimate device parameter --------------------------------------------%
lam = 2.*tau.*(sp.alpha^2-sp.beta^2./(rs.^4)).*prop.L./prop.v_bar;


%-- Evaluate transfer function -------------------------------------------%
rho_s = (rs-prop.rc)/prop.del;
Lambda = ((1-rho_s)+(1+rho_s).*exp(-lam))./2.*and(1<rho_s,rho_s<coth(lam./2))+...
    exp(-lam).*and(-1<rho_s,rho_s<1)+...
    ((1+rho_s)+(1-rho_s).*exp(-lam))./2.*and(-coth(lam./2)<rho_s,rho_s<-1);


end

