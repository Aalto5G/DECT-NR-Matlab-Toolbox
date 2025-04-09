%
% User plane data flow ie parser
% 
% input 
%   rx packet with header 
% output
%   extracted data sdu 

% Kalle Ruttik
% 23.11.2023

function [user_plane_data_flow_message_ie_struct] = user_plane_data_flow_ie_parser(ie_sdu,ie_len)


% cluster_beacon_msg_struct.mac_ext_len = 2;
% cluster_beacon_msg_struct.ie_type_len = 6;
% 
% if mac_ext == 1
%   cluster_beacon_msg_struct.Length_len = 8;
% else 
%   cluster_beacon_msg_struct.Length_len = 16;
% end

user_plane_data_flow_message_ie_struct.mac_sdu = ie_sdu(1:ie_len);

end