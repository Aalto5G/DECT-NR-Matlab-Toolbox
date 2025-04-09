%
% synchronization to DECT packet 
%
% NOTE: for now it doesn't sync but assumes that the packet starts at
% with first sample
%

% Kalle Ruttik
% 11.8.2023

function [rx_frame,info_rx] = dectSync(tx_frame)

% NO SYNC: assumes that the packet starts from the first sample

% correlation
% NOT IMPLEMENTED
% peak search
% NOT IMPLEMENTED

mu_inx = 1;    % 1 TX 1 RX
beta_inx = 1;  % N_DFT = 64
[info_rx] = dectPhyFrameParameters_Table431(mu_inx,beta_inx);

stf     = dectSyncTrainingField(info_rx);


c = filter((fliplr(conj(stf))),1,tx_frame);
[v,loc_start] = max(abs(c));

rx_frame = tx_frame((loc_start+1):end);

end
