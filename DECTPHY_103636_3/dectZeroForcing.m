%
% Zero Forcing equalizer
%

% Kalle Ruttik
% 11.8.2023

function [dect_grid_rx_equalized] = dectZeroForcing(dect_grid_rx,h_est,phy_Control_Field,transmission_modes,mu_beta)

N_eff_tx = transmission_modes.N_eff_tx;    % number of effective antennas 
N_DFT = mu_beta.N_DFT;
N_cp = mu_beta.N_cp;
N_TS = transmission_modes.N_TS;        % number of transmit streams 
N_beta_occ = mu_beta.N_beta_occ; %56 % number of occupied carriers 
N_ss = transmission_modes.N_ss;

k_beta_occ = [-N_beta_occ/2:-1 1:N_beta_occ/2];
half_shift = N_DFT/2+1;
tmp_addr= k_beta_occ+half_shift;

%%
if N_eff_tx <= 2
  N_step = 5;
else 
  N_step = 10;
end

% pilots locations 
[pilots,ind_pilots,ind_pilots_DFT,grid_withPilots] = dectPilots(phy_Control_Field, transmission_modes, mu_beta);

% pilots location in DFT grid 
dect_grid_h_est = zeros(size(dect_grid_rx));

dect_grid_h_est(ind_pilots_DFT) = h_est;

% dect_grid_h_est

% pilot symbols 
% N_PACKET_symb = size(dect_grid_rx,2)+1;
% N_PACKET_symb = 10;
if phy_Control_Field.Packet_Length_Type == 0
  N_PACKET_symb = (phy_Control_Field.phy_Packet_Length+1)*mu_beta.N_SLOTmu_symb/mu_beta.N_SLOTmu_subslot;
else 
 if phy_Control_Field.Packet_Length_Type == 1
   N_PACKET_symb = (phy_Control_Field.phy_Packet_Length+1)*mu_beta.N_SLOTmu_symb;
 end
end
% N_PACKET_symb


n_list = 0:(floor(N_PACKET_symb/N_step)-1);
% locPilotSymbol = 1 + floor(t_inx/4) + n*N_step;
locPilot = (0:(N_beta_occ/4-1));

first_Symbol_in_DFT = -N_beta_occ/2 +N_DFT/2+1;

% est in freq domain
% dect_grid_h_est

%% hack for testing what happens with the estimate in freq domain
for t_inx = 1:N_eff_tx
  for n_inx=1:length(n_list)
    n                             = n_list(n_inx);
    locPilotSymbol                = 1 + floor(t_inx/4) + n*N_step;
    locPilot                      = locPilot*4+mod((t_inx-1+mod(n,2)*2),4)+1;



    tmpLoc=find(dect_grid_h_est(:,locPilotSymbol+1,t_inx)~=0);
    p1 = dect_grid_h_est(tmpLoc,locPilotSymbol+1,t_inx);

    for i1 = 1:(length(tmpLoc)-1)
        df = (p1(i1+1)-p1(i1))/(tmpLoc(i1+1)-tmpLoc(i1));
        
        for i2 = 1:(tmpLoc(i1+1)-tmpLoc(i1)-1)
          dect_grid_h_est(tmpLoc(i1)+i2,locPilotSymbol+1,t_inx) = p1(i1)+i2*df;
        end
    end
    
    
    % estimates for corner cases 
    
    % at the lower edge
    if tmpLoc(1) ~= 5
    	df = (p1(2)-p1(1))/(tmpLoc(2)-tmpLoc(1));
        for i2 = 5:(tmpLoc(1)-1)
          dect_grid_h_est(i2,locPilotSymbol+1,t_inx) = p1(1)-(tmpLoc(1)-i2+1)*df;
        end
    end
    
    % at the upper edge
    if tmpLoc(end) ~= 61
    	df = (p1(end)-p1(end-1))/(tmpLoc(end)-tmpLoc(end-1));    

        for i2 = (tmpLoc(end)+1):61
          dect_grid_h_est(i2,locPilotSymbol+1,t_inx) = p1(end)+(i2-tmpLoc(end))*df;
        end

    end

  end
end

% dect_grid_h_est


% %% initial version
% for t_inx = 1:N_eff_tx
%   for n_inx=1:length(n_list)
%     n                             = n_list(n_inx);
%     locPilotSymbol                = 1 + floor(t_inx/4) + n*N_step;
%     locPilot                      = i1*4+mod((t_inx-1+mod(n,2)*2),4)+1;
% 
% 
% 
%     tmpLoc=find(dect_grid_h_est(:,locPilotSymbol+1,t_inx)~=0);
%     p1 = dect_grid_h_est(tmpLoc,locPilotSymbol+1,t_inx);
% 
%     for i1 = 1:(length(tmpLoc)-1)
%         df = (p1(i1+1)-p1(i1))/(tmpLoc(i1+1)-tmpLoc(i1));
% 
%         for i2 = 1:(tmpLoc(i1+1)-tmpLoc(i1)-1)
%           dect_grid_h_est(tmpLoc(i1)+i2,locPilotSymbol+1,t_inx) = p1(i1)+i2*df;
%         end
%     end
% 
%     % estimates for corner cases 
% 
% if(~isempty(tmpLoc))
%     if tmpLoc(1) ~= tmp_addr(1)
%       df = (p1(2)-p1(1))/(tmpLoc(2)-tmpLoc(1));
%       for i2 = tmp_addr(1):(tmpLoc(1)-1)
%         dect_grid_h_est(i2,locPilotSymbol+1,t_inx)= p1(1) - i2*df;        
%       end
%     end
%     if tmpLoc(end) ~= tmp_addr(end)
%       df = (p1(end)-p1(end-1))/(tmpLoc(end)-tmpLoc(end-1));
%       for i2 = tmpLoc(end):tmp_addr(end)
%         dect_grid_h_est(i2,locPilotSymbol+1,t_inx)= p1(end) + i2*df;
%       end
%     end 
%   end
% end
% 
% end
% 
% dect_grid_h_est

% n_list
% tmpLoc                = 1 + floor(t_inx/4) + n_list*N_step+1


% est in time domain
for t_inx = 1: N_eff_tx % stream index
  tmpLoc                = (1 + floor(t_inx/4) + n_list*N_step)+1;

  if length(tmpLoc) == 1
    for i2 = 1:6
      dect_grid_h_est(:,i2,t_inx) = dect_grid_h_est(:,tmpLoc,t_inx)*exp(1i*(i2-2)*pi/4);
    end
  else
  for i1 = 1:(length(tmpLoc)-1)
    p11(:,1) = dect_grid_h_est(:,tmpLoc(i1),t_inx);
    p11(:,2) = dect_grid_h_est(:,tmpLoc(i1+1),t_inx);
    
    df = (p11(:,2)-p11(:,1))./(tmpLoc(i1+1)-tmpLoc(i1));

     
    for i2 = 1:(tmpLoc(i1+1)-tmpLoc(i1)-1)
      dect_grid_h_est(:,tmpLoc(i1)+i2,t_inx) = (p11(:,1)+i2*df);
    end
  end
  
  % corner case for the end symbols 
   if tmpLoc(end) ~= N_PACKET_symb+1
    p11(:,1) = dect_grid_h_est(:,tmpLoc(end-1),t_inx);
    p11(:,2) = dect_grid_h_est(:,tmpLoc(end),t_inx);    
    df = (p11(:,2)-p11(:,1))./(tmpLoc(end)-tmpLoc(end-1));
    for i2 = (tmpLoc(end)+1):N_PACKET_symb+1
      dect_grid_h_est(:,i2,t_inx) = p11(:,2)+(i2- tmpLoc(end))*df;
    end

  else 
    p11(:,1) = dect_grid_h_est(:,tmpLoc(1),t_inx);
    for i2 = (tmpLoc(end)+1):N_PACKET_symb
      dect_grid_h_est(:,i2,t_inx) = p11(:,1);
    end

  end 
end 
% dect_grid_h_est

% 
% % initial version 
% for t_inx = 1:N_eff_tx
%   for time_inx = tmp_addr(1):tmp_addr(end)
%     tmpLoc=find(dect_grid_h_est(time_inx,:,t_inx)~=0);
%     p1 = dect_grid_h_est(time_inx,tmpLoc,t_inx);    
%     for i1 = 1:(length(tmpLoc)-1)
% 
%         df = (p1(i1+1)-p1(i1))/(tmpLoc(i1+1)-tmpLoc(i1));
% 
%         for i2 = 1:(tmpLoc(i1+1)-tmpLoc(i1)-1)
%           dect_grid_h_est(time_inx,tmpLoc(i1)+i2,t_inx) = p1(i1)+df;
%         end
%     end
% 
% 
%     if ~isempty(tmpLoc)
%      if tmpLoc(end) ~= N_PACKET_symb
%      %	N_PACKET_symb
%      %	p1~ 
%      %	tmpLoc
%      df = (p1(end)-p1(end-1))/(tmpLoc(end)-tmpLoc(end-1));
%       for i2 = tmpLoc(end):N_PACKET_symb
%         dect_grid_h_est(time_inx,i2,t_inx)= p1(end) + df;
%       end
%     end
% 
%     % else
%     % 
%     %   for i2 = tmpLoc(end):N_PACKET_symb
%     %     dect_grid_h_est(time_inx,i2,t_inx)= p1(end);
%     %   end
%     end
% 
%   end
% end 

% therethdect_grid_h_est

% estimates in frequency domain 
% estimates in time domain

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% computation ch est values at each location 
dect_grid_rx_eq_DFT = zeros(size(dect_grid_rx));
%dect_grid_rx_eq_DFT(:,2:end,:) = dect_grid_rx(:,2:end,:)./conj(dect_grid_h_est(:,2:size(dect_grid_rx,2),:));
dect_grid_rx_eq_DFT(:,2:end,:) = dect_grid_rx(:,2:end,:)./(dect_grid_h_est(:,2:size(dect_grid_rx,2),:));
dect_grid_rx_equalized=zeros(N_beta_occ,size(dect_grid_rx,2),size(dect_grid_rx,3));

% dect_grid_rx_eq_DFT

% equalization and making final grid
for t_inx = 1:size(dect_grid_rx,3)
  for n_inx = 1:size(dect_grid_rx,2)
    dect_grid_rx_equalized(:,n_inx,t_inx) = dect_grid_rx_eq_DFT(tmp_addr,n_inx,t_inx);
  end
end

end 
