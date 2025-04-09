%
% takes in binary sequence of the message and the physical packet length
% options 
% padds the data till the next packet size 
%

% Kalel Ruttik
% 28.10.2023

function [msg_bin] = mac_add_padding(msg_bin, phy_Control_Field, transmission_modes, mu_beta)

len_msg = length(msg_bin);

[N_symb,N_TB_bits] = mac_fit_data_into_min_symbols(len_msg, phy_Control_Field, transmission_modes, mu_beta);
phy_Control_Field.phy_Packet_Length = N_symb;

% %% computes the packet length options 
% % estimates the packet length
% % for each subblock length
% for i1 =1:15
% phy_Control_Field.phy_Packet_Length = i1;
% [ind_pdc]   = dectPDCind(phy_Control_Field,transmission_modes,mu_beta);
% N_PDC_re = length(ind_pdc);
% [N_TB_bits] = dectTransportBlockSize(N_PDC_re,phy_Control_Field,transmission_modes,mu_beta);
% if (len_msg<= N_TB_bits)
%   N_symb = i1;
%   break
% end
% %bits_per_symb(i1) = N_TB_bits;
% end

%% extend the msg_bin with padding bits 
if len_msg == N_TB_bits
  msg_bin = msg_bin;
  
elseif (len_msg+1*8) == N_TB_bits
  % create the padding header 1
  MAC_ext = [1 1];
  mac_extension_field_ie_padding = [0 0 0 0 0 0];
  msg_bin = [msg_bin MAC_ext mac_extension_field_ie_padding];
  
elseif (len_msg+2*8) == N_TB_bits
  MAC_ext = [1 1];
  mac_extension_field_ie_padding = [1 0 0 0 0 0];
  len = 1;
  len_bin = fliplr(de2bi(1,8));
  msg_bin = [msg_bin MAC_ext mac_extension_field_ie_padding len_bin];
  
else 
  len_padding = N_TB_bits - (len_msg);
  if (len_padding-2*8) < 256
    MAC_ext = [0 1];
    mac_extension_field_ie_padding = [0 0 0 0 0 0];
    len = len_padding-2*8;
    length_bin = fliplr(de2bi(len,8));
    padding_bin =zeros(1,len);
    msg_bin = [msg_bin MAC_ext mac_extension_field_ie_padding length_bin padding_bin];
   
  else
    MAC_ext = [1 0];
    mac_extension_field_ie_padding = [0 0 0 0 0 0];
    len = len_padding-3*8
    length_bin = fliplr(de2bi(len,16));
    padding_bin =zeros(1,len);
    msg_bin = [msg_bin MAC_ext mac_extension_field_ie_padding length_bin padding_bin];
    
  end
end


end
