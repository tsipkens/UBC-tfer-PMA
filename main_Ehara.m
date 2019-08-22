
% MAIN      Script used in plotting different transfer functions.
% Author:   Timothy Sipkens, 2019-06-25
%=========================================================================%


%-- Initialize script ----------------------------------------------------%
clear;
close all;

V = 10; % voltage to replicate Ehara et al.
omega = 1000*0.1047; % angular speed, converted from rpm to rad/s

e = 1.60218e-19; % electron charge [C]
m = linspace(1e-10,7,601)*e; % vector of mass
% m = linspace(1e-10,6,601)*e; % vector of mass

z = 1; % integer charge state

rho_eff = 900; % effective density
d = (6.*m./(rho_eff.*pi)).^(1/3);
    % specify mobility diameter vector with constant effective density

prop = tfer_PMA.prop_CPMA('Ehara'); % get properties of the CPMA

%=========================================================================%
%-- Finite difference solution -------------------------------------------%
tic;
[tfer_FD,~,n] = tfer_PMA.tfer_FD([],...
    m,d,1,prop,'V',V,'omega',omega);
t(1) = toc;


%=========================================================================%
%-- Transfer functions for different cases -------------------------------%
%-- Setup for centriputal force ------------------------------------------%
B = tfer_PMA.dm2zp(d,z,prop.T,prop.p);
tau = B.*m;
D = prop.D(B);
sig = sqrt(2.*prop.L.*D./prop.v_bar);
D0 = D.*prop.L/(prop.del^2*prop.v_bar); % dimensionless diffusion coeff.


%-- Particle tracking approaches -----------------------------------------%
%-- Plug flow ------------------------------------------------------------%
%-- Method 1S ------------------------------%
tic;
[tfer_1S,G0_1S] = tfer_PMA.tfer_1S([],m,d,z,prop,'V',V,'omega',omega);
t(2) = toc;

%-- Method 1S, Ehara et al. ----------------%
tfer_Ehara = tfer_PMA.tfer_Ehara([],m,d,z,prop,'V',V,'omega',omega);



%-- Parabolic flow -------------------------------------------------------%
%-- Method 1S ------------------------------%
tic;
[tfer_1S_pb,G0_1S_pb] = tfer_PMA.tfer_1S_pb([],m,d,z,prop,'V',V,'omega',omega);
t(8) = toc;



%=========================================================================%
%-- Plot different transfer functions with respect to m/m* ---------------%
m_plot = m./e;

figure(2);
plot(m_plot,tfer_1S);
hold on;
plot(m_plot,tfer_Ehara);
plot(m_plot,tfer_1S_pb);
plot(m_plot,min(tfer_FD,1),'k');
hold off;

% ylim([0,1.2]);

xlabel('s')
ylabel('{\Lambda}')

