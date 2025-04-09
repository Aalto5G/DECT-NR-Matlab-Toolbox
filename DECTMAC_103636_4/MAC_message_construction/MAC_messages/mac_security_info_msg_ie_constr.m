%
% MAC Security Info IE message construction
%

% Jaakko Niemistö
% 2.4.2024


function [msg_bin] = mac_security_info_msg_ie_constr(...
    version,key_index,security_iv_type,HPC)

mac_security_info_msg_struct.version = 2;
mac_security_info_msg_struct.key_index = 2;
mac_security_info_msg_struct.security_iv_type = 4;
mac_security_info_msg_struct.HPC = 32;

version_bin = fliplr(de2bi(double(version),mac_security_info_msg_struct.version));
key_index_bin = fliplr(de2bi(double(key_index),mac_security_info_msg_struct.key_index));
security_iv_type_bin = fliplr(de2bi(double(security_iv_type),mac_security_info_msg_struct.security_iv_type));
HPC_bin = fliplr(de2bi(double(HPC),mac_security_info_msg_struct.HPC));

msg_bin = [version_bin key_index_bin security_iv_type_bin HPC_bin];

% Header type d)
ie_type = [0 1 0 0 0 0]; % MAC security info message type 
len = length(msg_bin);
mac_mux_pdu = mac_mux_header_d_constr(ie_type, len);

msg_bin = [mac_mux_pdu msg_bin];

end 
