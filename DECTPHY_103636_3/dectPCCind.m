%
% generates location indixes for PCC signal
%
% 98 symbols
%


% Kalle Ruttik
% 9.8.2023

function [ind_pcc] = dectPCCind(transmission_modes,mu_beta)

% function [ind_pcc] = dectPCCind(phy_Control_Field,transmission_modes,mu_beta)

%% 
N_eff_tx = transmission_modes.N_eff_tx;    % number of effective antennas 
N_TS = transmission_modes.N_TS;        % number of transmit streams 
N_beta_occ = mu_beta.N_beta_occ; %56 % number of occupied carriers 

beta = mu_beta.beta;

locHalf = mu_beta.N_DFT/2;

N_PACKET_symb = 5;
% N_PACKET_symb = 10;
% if phy_Control_Field.Packet_Length_Type == 0
%  N_PACKET_symb = phy_Control_Field.phy_Packet_Length*mu_beta.N_SLOTmu_symb/mu_beta.N_SLOTmu_subslot;
% else 
%  if phy_Control_Field.Packet_Length_Type == 1
%    N_PACKET_symb = phy_Control_Field.phy_Packet_Length*mu_beta.N_SLOTmu_symb;
%  end
%end

%%

inc_pcc = [];
free_loc = [];
N_DFT = mu_beta.N_DFT;
N_beta_occ = mu_beta.N_beta_occ; %128; % number of occupied carriers 

phy_Packet_Length = 1; % phy_Control_Field.phy_Packet_Length;
packet_Length_Type = 0; % phy_Control_Field.Packet_Length_Type;

% pilots locations 
[pilots,ind_pilots,ind_pilots_DFT,grid_withPilots] = dectPCCPilots(transmission_modes, mu_beta);

% [pilots,ind_pilots,ind_pilots_DFT,grid_withPilots] = dectPilots(phy_Control_Field, transmission_modes, mu_beta);
% [pilots,ind_pilots,grid_withPilots,locPilotsInSym, locPilotSym, yDRS]  = dectPilots(phy_Control_Field,transmission_modes,mu_beta);

RE_in_Packet = N_beta_occ*N_PACKET_symb;

tmp_grid = zeros(N_beta_occ,N_PACKET_symb);
tmp_grid(mod(ind_pilots,RE_in_Packet)) = 1;

% knock out the RE that are allocated 
if (N_TS == 1) & (N_DFT == 64)
  ind_pcc = find(tmp_grid(:,2:3)==0)+N_beta_occ;
  return
end

N_unallocated = 98;
tmp_address = 0;
alloc_inx = 0;
if length(find(tmp_grid(:,2)==0)) <= N_unallocated
   tmp_address = find(tmp_grid(:,2)==0)+N_beta_occ;
   alloc_inx = length(tmp_address);
   if alloc_inx == 98
     ind_pcc = tmp_address;
     return
   end
   if (alloc_inx+length(find(tmp_grid(:,3)==0))) <= N_unallocated
     tmp_address = [tmp_address;(find(tmp_grid(:,3)==0) + 2*N_beta_occ)];
     alloc_inx = alloc_inx + length(tmp_address);
     if alloc_inx == 98
       ind_pcc = tmp_address;
       return
     end
  
     if (alloc_inx + length(find(tmp_grid(:,4)==0))) <= N_unallocated
       tmp_address = [tmp_address;(find(tmp_grid(:,4)==0) + 3*N_beta_occ)];
       alloc_inx = alloc_inx + length(tmp_address);
       if alloc_inx == 98
         ind_pcc = tmp_address;
         return
       end
  
     else
       tmpLoc = find(tmp_grid(:,4)==0);
       tmpMatrix = reshape(tmpLoc',8,7)';
       tmpMatrix = tmpMatrix(:);
       tmp_address =[tmp_address;(tmpMatrix(1:((N_unallocated-alloc_inx)))+3*N_beta_occ)];
     end
   else
     tmpLoc = find(tmp_grid(:,3)==0);
     tmpMatrix = reshape(tmpLoc',8,7)';
     tmpMatrix = tmpMatrix(:);
     tmp_address =[tmp_address;(tmpMatrix(1:((N_unallocated-alloc_inx)))+2*N_beta_occ)];
   end
else 
  tmpLoc = find(tmp_grid(:,2)==0);
  tmpMatrix = reshape(tmpLoc',8,7)';
  tmpMatrix = tmpMatrix(:);
  tmp_address = tmpMatrix(1:((N_unallocated-alloc_inx)))+N_beta_occ;
end

ind_pcc = tmp_address;
% % %%
% % k_beta_occ = [-N_beta_occ/2:-1 1:N_beta_occ/2];
% % halfShift = N_DFT/2+1;
% % 
% % txGrid = zeros(N_DFT,3);
% % tmpLoc = k_beta_occ + halfShift;
% % for i1=1:3
% %   txGrid(tmpLoc,i1) = 1;
% % end
% % 
% % 
% % % knock out the RE that are allocated 
% % if (ind_pilotSym(1) == 1)
% %   for n_tx_inx = 1:size(ind_pilotsInSym,3)
% %    tmpPilots = ind_pilotsInSym(:,1,n_tx_inx)+halfShift;
% %    txGrid(tmpPilots,1)=0;
% %   end
% % end
% % if (ind_pilotSym(2) == 1)
% %   for n_tx_inx = 1:size(ind_pilotsInSym,3)
% %    tmpPilots = ind_pilotsInSym(:,2,n_tx_inx)+halfShift;
% %    txGrid(tmpPilots,2)=0;
% %   end
% % end
% % 
% % % count locations where the PCC can be allocated
% % N_unallocated = 98;
% % alloc_inx = 0;
% % if length(find(txGrid(:,1)==1)) >= N_unallocated
% %   tmpLoc = find(txGrid(:,1)==1);
% %   tmpMatrix = reshape(tmpLoc',8,7)';
% %   tmpMatrix = tmpMatrix(:);
% %   locPCC1 = tmpMatrix(1:((N_unallocated-alloc_inx)));
% %   free_loc = tmpMatrix(((N_unallocated-(length(locPCC1)))+1):end);
% %   ind_pcc(1).l = locPCC1;
% %   return
% % else 
% %   locPCC1 = find(txGrid(:,1)==1);
% %   ind_pcc(1).l = locPCC1;
% %   alloc_inx = length(locPCC1);
% %   if alloc_inx + find(txGrid(:,2)==1) >= N_unallocated
% %     tmpLoc = find(txGrid(:,2)==1);
% %     tmpMatrix = reshape(tmpLoc',8,7)';
% %     tmpMatrix = tmpMatrix(:);
% %     locPCC2 = tmpMatrix(1:((N_unallocated-alloc_inx)));
% %     free_loc = tmpMatrix(((N_unallocated-(alloc_inx+length(locPCC2)))+1):end);
% %     ind_pcc(2).l = locPCC2;
% %     return  
% %   else
% %     locPCC2 = find(txGrid(:,2)==1);
% %     ind_pcc(2).l = locPCC2;
% % 
% %     alloc_inx = alloc_inx+length(locPCC2);
% % 
% %     tmpLoc = find(txGrid(:,3)==1);
% %     tmpMatrix = reshape(tmpLoc',8,7)';
% %     tmpMatrix = tmpMatrix(:);
% %     locPCC3 = tmpMatrix(1:((N_unallocated-alloc_inx)));
% %     ind_pcc(3).l = locPCC3;
% %     free_loc = tmpMatrix(((N_unallocated-(alloc_inx+length(locPCC3)))+1):end);
% %   end
% % end
% % 
% % if alloc_inx < 98
% %  locPCC2 = find(txGrid(:,2)==1);
% %  if alloc_inx + length(locPCC2) < 98
% %    alloc_inx = alloc_inx + length(locPCC2);
% %  else 
% %   tmpMatrix = reshape(k_beta_occ',8,7)';
% %   tmpMatrix = tmpMatrix(:);
% %   locPCC3 = tmpMatrix(1:(N_unallocre-(length(locPCC1)+length(locPCC2))));
% %   tmpLoc = tmpMatrix(((N_unallocre-(length(locPCC1)+length(locPCC2)))+1):end);  
% %  end
% % 
% % end
% % % 
% % % locPCC1 = k_beta_occ;
% % % halfShift = (N_beta_occ/2)+1;
% % % tmpLoc = locPCC1 +halfShift;
% % % if (ind_pilotSym(1) == 1)
% % %   for n_tx_inx = 1:size(ind_PilotsInSym,3)
% % %    tmpPilots = ind_pilotsInSym(:,1,n_tx_inx)+halfShift;
% % %   end
% % % end
% % % 
% % % t = 0; % goes through all the antenna streams
% % % addr1 = 0:(Nbetaocc/4-1);
% % % locPCC1(addr1*4+mod((t+mod(l,2)*2),4)+1) = [];
% % % 
% % % l = 2;
% % % locPCC2 = locOccup;
% % % locPCC3 = [];
% % % tmpLoc = locOccup;
% % % if (length(locPCC1)+length(locPCC2)) < Nunallocre
% % %   l = 3;
% % % 
% % %   tmpMatrix = reshape(locOccup',8,7)';
% % %   tmpMatrix = tmpMatrix(:);
% % %   locPCC3 = tmpMatrix(1:(Nunallocre-(length(locPCC1)+length(locPCC2))));
% % %   tmpLoc = tmpMatrix(((Nunallocre-(length(locPCC1)+length(locPCC2)))+1):end);
% % % end
% % % 
% % % %%
% % % % count free symbols
% % % % mu = 1
% % % tmpl = Npacketsym - 4;
% % % 
% % % if length(tmpLoc)>0
% % %   locData(1).l = sort(tmpLoc);
% % % end
% % % 
% % % %locData(1).l = locData;
% % % for l = 5:Npacketsym
% % % locData(l-3).l = locOccup;
% % % end


end
