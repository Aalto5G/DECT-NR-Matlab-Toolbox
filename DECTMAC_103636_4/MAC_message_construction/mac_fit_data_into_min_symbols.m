%
% finds what is the minimum set of symbols whre the data fits 
%


% Kalle Ruttik 
function [N_symb,N_TB_bits] = mac_fit_data_into_min_symbols(len_msg, phy_Control_Field, transmission_modes, mu_beta)

% len_msg = length(msg_bin);

%% computes the packet length options 
% estimates the packet length
% for each subblock length
for i1 =1:15
phy_Control_Field.phy_Packet_Length = i1;
[ind_pdc]   = dectPDCind(phy_Control_Field,transmission_modes,mu_beta);
N_PDC_re = length(ind_pdc);
[N_TB_bits] = dectTransportBlockSize(N_PDC_re,phy_Control_Field,transmission_modes,mu_beta);
if (len_msg<= N_TB_bits)
  N_symb = i1;
  break
end
%bits_per_symb(i1) = N_TB_bits;
end

% phy_Control_Field.phy_Packet_Length = N_symb;

end
