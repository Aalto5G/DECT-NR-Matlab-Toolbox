%
% Creates header type binary vector 
%

% Kalle Ruttik
% 28.10.2023

function [msg_bin] = mac_MAC_Header_Type_constr(version,mac_security,mac_header_type)

mac_header_type_struct.version_len = 2; % 2 bits 
mac_header_type_struct.mac_security_len = 2; % 2 bits 
mac_header_type_struct.mac_header_type_len = 4; % 4 bits 

version_bin = fliplr(de2bi(double(version),mac_header_type_struct.version_len));
mac_security_bin = fliplr(de2bi(double(mac_security),mac_header_type_struct.mac_security_len));
mac_header_type_bin = fliplr(de2bi(double(mac_header_type),mac_header_type_struct.mac_header_type_len));
msg_bin = [version_bin mac_security_bin mac_header_type_bin];


% MAC_header_type.version = 0; % 2 bits 
% MAC_header_type.version_len = 2; % 2 bits 
% MAC_header_type.MAC_security = 0; % 2 bits 
% MAC_header_type.MAC_security_len = 2; % 2 bits 
% MAC_header_type.MAC_header_type = 0; % 4 bits 
% MAC_header_type.MAC_header_type_len = 4; % 4 bits 

end