%
% user plane data flow 1
%

% Kalle Ruttik
% 22.11.2023

function [msg_bin] = user_plane_data_flow_ie_constr(flow_nr, data, data_len)

% ie type defines the length of the ie payload
% type c) without length indication
switch flow_nr
  case 1
    ie_type = [0 0 0 0 1 1];
  
  case 2
    ie_type = [0 0 0 1 0 0];

  case 3
    ie_type = [0 0 0 1 0 1];
  case 4
    ie_type = [0 0 0 1 1 0];
  otherwise
    disp('Error in user plane data flow nr')
end 

if data_len < 256
  mac_extension_field_encoding = [0 1];
else
  mac_extension_field_encoding = [1 0];
end
mac_mux_pdu = [mac_extension_field_encoding ie_type];

len_sdu = data_len;

if len_sdu <=256
  % create a medium sdu
  length_bin = fliplr(de2bi(len_sdu,8));
else % len_sdu > 256
  % create large SDU
  length_bin = fliplr(de2bi(len_sdu,16));
end 

data_bin = data;

msg_bin = [mac_mux_pdu length_bin data_bin];

end