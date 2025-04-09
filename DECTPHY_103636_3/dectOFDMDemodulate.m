%
% Demodulates dect OFDM symbols 
% 
% Symbols are in frew domain at the 
%

% Kalle Ruttik
% 11.8.2023

function [dect_grid,info] = dectOFDMDemodulate(waveform,mu_beta)

%N_eff_tx = transmission_modes.N_eff_tx;    % number of effective antennas 
N_DFT = mu_beta.N_DFT;
N_cp = mu_beta.N_cp;
N_beta_occ = mu_beta.N_beta_occ; %56 % number of occupied carriers 
% N_TS = transmission_modes.N_TS;        % number of transmit streams 
% N_ss = transmission_modes.N_ss;

k_beta_occ = [-N_beta_occ/2:-1 1:N_beta_occ/2];
half_shift = N_DFT/2+1;
tmp_addr= k_beta_occ+half_shift;
% 
% if phy_Control_Field.Packet_Length_Type == 0
%   N_PACKET_symb = phy_Control_Field.phy_Packet_Length*mu_beta.N_SLOTmu_symb/mu_beta.N_SLOTmu_subslot;
% else 
%   if phy_Control_Field.Packet_Length_Type == 1
%     N_PACKET_symb = phy_Control_Field.phy_Packet_Length*mu_beta.N_SLOTmu_symb;
%   end
% end

N_PACKET_symb = length(waveform)/(N_DFT+N_cp);

mu = mu_beta.mu;
switch mu
  case 1
    N_GISTF_symb = 2;
  case {2,4} 
    N_GISTF_symb = 3;
  case 8
    N_GISTF_symb = 4;
  otherwise 
    N_GISTF_symb = [];
    return
end

tmpLen = N_DFT+N_cp;
tmp_grid = reshape(waveform,tmpLen,length(waveform)/tmpLen);
dect_grid = zeros(N_DFT,size(tmp_grid,2)+1);
for i1 = 1:size(tmp_grid,2)
  dect_grid(:,i1+1) = fftshift(fft(tmp_grid((N_cp+1):(N_DFT+N_cp),i1)));
end

info.N_DFT = N_DFT;
info.N_cp = N_cp;
info.N_PACKET_symb = N_PACKET_symb+1;

end