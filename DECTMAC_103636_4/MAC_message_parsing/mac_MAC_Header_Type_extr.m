%
% Extracts the mac header type from binary vector into struct 
%

% Kalle Ruttik
% 26.10.2023

% parse into structure
function [mac_header_type_struct] = mac_header_type_extr(rx_msb_bin)
% MAC_header_type.version = 0; % 2 bits 
% MAC_header_type.version_len = 2; % 2 bits 
% MAC_header_type.MAC_security = 0; % 2 bits 
% MAC_header_type.MAC_security_len = 2; % 2 bits 
% MAC_header_type.MAC_header_type = 0; % 4 bits 
% MAC_header_type.MAC_header_type_len = 4; % 4 bits 

mac_header_type_struct.version = rx_msb_bin(1:2);
mac_header_type_struct.MAC_security = bi2de(fliplr(rx_msb_bin(3:4)));
mac_header_type_struct.MAC_header_type = bi2de(fliplr(rx_msb_bin(5:8)));

% MAC_header_type.version = 0; % 2 bits 
% MAC_header_type.version_len = 2; % 2 bits 
% MAC_header_type.MAC_security = 0; % 2 bits 
% MAC_header_type.MAC_security_len = 2; % 2 bits 
% MAC_header_type.MAC_header_type = 0; % 4 bits 
% MAC_header_type.MAC_header_type_len = 4; % 4 bits 

end