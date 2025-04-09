%
% locations of the data symbols 
%

% Kalle Ruttik
% 9.8.2023

function ind_pdc = dectPDCind(phy_Control_Field,transmission_modes,mu_beta)

N_eff_tx = transmission_modes.N_eff_tx;    % number of effective antennas 
N_DFT = mu_beta.N_DFT;
N_TS = transmission_modes.N_TS;        % number of transmit streams 
N_beta_occ = mu_beta.N_beta_occ; %56 % number of occupied carriers 

beta = mu_beta.beta;

% k_beta_occ = [-N_beta_occ/2:-1 1:N_beta_occ/2];

if phy_Control_Field.Packet_Length_Type == 0
  N_PACKET_symb = (phy_Control_Field.phy_Packet_Length+1)*mu_beta.N_SLOTmu_symb/mu_beta.N_SLOTmu_subslot;
else 
  if phy_Control_Field.Packet_Length_Type == 1
    N_PACKET_symb = (phy_Control_Field.phy_Packet_Length+1)*mu_beta.N_SLOTmu_symb;
  end
end


% grid Legth 
% combines the pilots into the grid
% reads out all the positions that are not occupied 
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

N_DF_symb = N_PACKET_symb - N_GISTF_symb;

% txGrid = zeros(N_beta_occ, N_PACKET_symb);

[pilots,ind_pilots,ind_pilots_DFT,grid_withPilots] = dectPilots(phy_Control_Field, transmission_modes, mu_beta);
% [pilots,ind_pilots,grid_withPilots,locPilotsInSym, locPilotSym, yDRS]  = dectPilots(phy_Control_Field,transmission_modes,mu_beta);

RE_in_Packet = N_beta_occ*N_PACKET_symb;

tmp_grid = zeros(N_beta_occ,N_PACKET_symb);
tmp_grid(mod(ind_pilots,RE_in_Packet)) = 1;

if (N_TS == 1) & (N_DFT == 64)
  ind_pcc = find(tmp_grid(:,2:3)==0)+N_beta_occ;
  grid_withPilots(ind_pcc) = 1;
  ind_pdc = find(grid_withPilots(:,2:(N_PACKET_symb-1))==0)+N_beta_occ;
  return
end

% [ind_pcc] = dectPCCind(phy_Control_Field,transmission_modes,mu_beta);

end

