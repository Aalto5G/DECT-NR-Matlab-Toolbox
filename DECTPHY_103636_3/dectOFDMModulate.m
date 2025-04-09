%
%
%

% Kalle Ruttik
% 10.11.2023

function [waveform,info] = dectOFDMModulate(dect_grid,transmission_modes,mu_beta)

N_eff_tx = transmission_modes.N_eff_tx;    % number of effective antennas 
N_DFT = mu_beta.N_DFT;
N_cp = mu_beta.N_cp;
N_TS = transmission_modes.N_TS;        % number of transmit streams 
N_beta_occ = mu_beta.N_beta_occ; %56 % number of occupied carriers 
N_ss = transmission_modes.N_ss;

k_beta_occ = [-N_beta_occ/2:-1 1:N_beta_occ/2];
half_shift = N_DFT/2+1;
tmp_addr= k_beta_occ+half_shift;

N_PACKET_symb = size(dect_grid,2)-1;

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


fft_grid = zeros(N_DFT,N_PACKET_symb,size(dect_grid,3));
t_grid = zeros(N_cp+N_DFT,N_PACKET_symb,size(dect_grid,3));
for t_inx = 1:size(dect_grid,3)
  for n_inx = 1:N_PACKET_symb
     fft_grid(tmp_addr,n_inx,t_inx) = dect_grid(:,n_inx,t_inx);
     t_grid(((N_cp+1)+[0:(N_DFT-1)]),n_inx,t_inx) = ifft(fftshift(fft_grid(:,n_inx,t_inx)),N_DFT);
     t_grid(1:N_cp,n_inx,t_inx) = t_grid(([(N_DFT+1):(N_cp+N_DFT)]),n_inx,t_inx);
  end
end

% add cp

waveform = t_grid(:,2:end,:);
waveform = waveform(:);
info.N_DFT = N_DFT;
info.N_cp = N_cp;
info.N_PACKET_symb = N_PACKET_symb;

% % halfShift = N_DFT/2+1;
% if (N_TS == 1) & (N_DFT == 64)
% 
% end


end