%
% Demodulates dect OFDM symbols 
% 
% Symbols are in frew domain at the 
%

% Kalle Ruttik
% 11.8.2023

function [h_est] = dectChannelEstimate(dect_grid_rx,phy_Control_Field,transmission_modes,mu_beta)

% pilots locations 
[pilots,ind_pilots,ind_pilots_DFT,grid_withPilots] = dectPilots(phy_Control_Field, transmission_modes, mu_beta);

% pilots conjugates 
pilots_conj = conj(pilots); %*exp(-1i*pi/4));
tmp_pilots_rx = dect_grid_rx(ind_pilots_DFT);

h_est = tmp_pilots_rx.*pilots_conj;

end