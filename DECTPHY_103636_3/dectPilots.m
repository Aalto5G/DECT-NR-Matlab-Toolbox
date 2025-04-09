%
% computes pilots location and values for DECT system
% 5.2.1
%

% Kalle Ruttik
% 8.8.2023

function [pilots,ind_pilots,ind_pilots_DFT,grid_withPilots] = dectPilots(phy_Control_Field, transmission_modes, mu_beta)

%function [plts,ind_pilots,grid_withPilots,locPilotsInSym,locPilotSym,pilotsInSym] = dectPilots(phy_Control_Field, transmission_modes, mu_beta)

%% 
N_eff_tx = transmission_modes.N_eff_tx;    % number of effective antennas 
N_TS = transmission_modes.N_TS;        % number of transmit streams 
N_beta_occ = mu_beta.N_beta_occ; %56 % number of occupied carriers 
N_DFT = mu_beta.N_DFT;
beta = mu_beta.beta;

locHalf = mu_beta.N_DFT/2;

% N_PACKET_symb = 10;
if phy_Control_Field.Packet_Length_Type == 0
  N_PACKET_symb = (phy_Control_Field.phy_Packet_Length+1)*mu_beta.N_SLOTmu_symb/mu_beta.N_SLOTmu_subslot;
else 
  if phy_Control_Field.Packet_Length_Type == 1
    N_PACKET_symb = (phy_Control_Field.phy_Packet_Length+1)*mu_beta.N_SLOTmu_symb;
  end
end
% N_PACKET_symb

%%

if N_eff_tx <= 2
  N_step = 5;
else 
  N_step = 10;
end
% PacketLength = 5;

%% pilot signal values from the spec

ym0B1 = [1, 1, 1, 1,-1, 1, 1, -1, -1, 1, 1, 1, 1, -1, 1, -1, 1, 1, -1, 1, -1, 1, -1, 1, 1, 1, 1, 1, -1, 1, -1, -1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, -1, 1, 1, 1, -1, 1, 1, -1, -1, 1, -1, -1, -1];
ym0B2=[ym0B1 ym0B1];
ym0B4=[ym0B2 ym0B2];
ym0B8=[ym0B4 ym0B4];
ym0B12=[ym0B4 ym0B4 ym0B4];
ym0B16=[ym0B8 ym0B8];


switch beta
  case 1
    tmpY = ym0B1;
%    yDRS = ym0B1(4*i1+mod(t,4)+1);
  case 2
    tmpY = ym0B2;
%    yDRS = ym0B2(4*i1+mod(t,4)+1);
  case 4
    tmpY = ym0B4;
%    yDRS = ym0B4(4*i1+mod(t,4)+1);
  case 8
    tmpY = ym0B8;
%    yDRS = ym0B8(4*i1+mod(t,4)+1);  
  case 12
    tmpY = ym0B12;
%    yDRS = ym0B12(4*i1+mod(t,4)+1);    
  case 16
    tmpY = ym0B16;
%    yDRS = ym0B16(4*i1+mod(t,4)+1);    
  otherwise
    tmpY = [];
end

%% inseting pilots into the packet grid
n_list = 0:(floor(N_PACKET_symb/N_step)-1);
i1 = (0:(N_beta_occ/4-1));
k_beta_occ = [-N_beta_occ/2:-1 1:N_beta_occ/2]+locHalf+1;
grid_withPilots = zeros(N_beta_occ,N_PACKET_symb,N_eff_tx);
dect_grid_DFT = zeros(N_DFT,N_PACKET_symb,N_eff_tx);

for t_inx = 1:N_eff_tx
  for n_inx=1:length(n_list)
    n                             = n_list(n_inx);
    locPilotSymbol                = 1 + floor(t_inx/4) + n*N_step;
    locPilot                      = i1*4+mod((t_inx-1+mod(n,2)*2),4)+1;
    tmp_pilots                    = tmpY(4*i1+mod(t_inx-1,4)+1);
    grid_withPilots(locPilot,locPilotSymbol+1,t_inx) = tmp_pilots;
    dect_grid_DFT(k_beta_occ,locPilotSymbol+1,t_inx) = grid_withPilots(:,locPilotSymbol+1,t_inx);
  end
end

ind_pilots = find(grid_withPilots~=0);
ind_pilots_DFT = find(dect_grid_DFT~=0);
pilots = grid_withPilots(ind_pilots);


% % %% location computation
% % n_list = 0:(floor(N_PACKET_symb/N_step)-1);
% % i1 = (0:(N_beta_occ/4-1));
% % % t = 1; %stream, could be from 1 2 4 8
% % % n = 0; %symbol index computed as 0:(floor(NPacketSymbol/Nstep)-1);
% % 
% % k_beta_occ = [-N_beta_occ/2:-1 1:N_beta_occ/2];
% % 
% % locPilotsInSym = zeros(length(i1),floor(N_PACKET_symb/N_step),N_eff_tx);
% % pilotsInSym = zeros(length(i1),floor(N_PACKET_symb/N_step),N_eff_tx);
% % locPilotSym = zeros(floor(N_PACKET_symb/N_step),N_eff_tx);
% % for t_inx = 1:N_eff_tx
% %   for n_inx=1:length(n_list)
% %     n                             = n_list(n_inx);
% %     locPilotSymbol                = 1 + floor(t_inx-1/4) + n*N_step;
% %     locPilot                      = k_beta_occ(i1*4+mod((t_inx-1+mod(n,2)*2),4)+1);
% %     pilots                        = tmpY(4*i1+mod(t_inx-1,4)+1);
% %     locPilotsInSym(:,n_inx,t_inx) = locPilot;
% %     pilotsInSym(:,n_inx,t_inx)    = pilots;
% %     locPilotSym(n_inx,t_inx)      = locPilotSymbol;
% %   end
% % end
% % 
% % % n = n_list(0)
% % % locPilotSymbol = 1 + floor(t/4) + n*N_step;
% % % locPilot00 = k_beta_occ(i1*4+mod((t+mod(n,2)*2),4)+1);
% % % 
% % % n = 1;
% % % locPilot01 = k_beta_occ(i1*4+mod((t+mod(n,2)*2),4)+1);
% % 
% % 
% % %% pilto signal generation 
% % % beta == 1

end

