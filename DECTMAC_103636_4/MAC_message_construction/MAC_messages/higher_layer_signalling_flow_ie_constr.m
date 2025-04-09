%
% higher layer signalling flow 1 or 2 ie constrcution
%

% Kalle Ruttik
% 22.11.2023

function [msg_bin] = higher_layer_signalling_flow_ie_constr(flow_nr, data, data_len)

% ie type defines the length of the ie payload
% type c) without length indication
switch flow_nr
  case 1
    ie_type = [0 0 0 0 0 1];
    mac_extension_field_encoding = [0 1];
  case 2
    ie_type = [0 0 0 0 0 1];
    mac_extension_field_encoding = [0 1];
end    
mac_mux_pdu = [mac_extension_field_encoding ie_type];

msg_bin = [mac_mux_pdu];

end