%
% Demodulates dect PCC OFDM symbols 
% 
% pcc locations are in the first two or three symbols
%

% Kalle Ruttik
% 21.11.2023

function [h_est] = dectPCCSymbolsChannelEstimate(dect_grid_rx,transmission_modes,mu_beta)

% pilots locations 
[pilots,ind_pilots,ind_pilots_DFT,grid_withPilots] = dectPCCPilots(transmission_modes, mu_beta);

% pilots conjugates 

%[pilots_mod] = dectSymbolMapping(pilots,0);
%pilots_conj = conj(pilots_mod);
pilots_conj = conj(pilots); % *exp(1i*pi/4)
tmp_pilots_rx = dect_grid_rx(ind_pilots_DFT);

h_est = tmp_pilots_rx.*pilots_conj;

end