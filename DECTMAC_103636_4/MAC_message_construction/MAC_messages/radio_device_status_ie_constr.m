%
% radio device status ie constrcution
%

% Kalle Ruttik
% 10.05.2024

function [msg_bin] = radio_device_status_ie_constr(status_flag,duration)


radio_device_status_ie.reserved_len = 2;
radio_device_status_ie.status_flag_len = 2;
radio_device_status_ie.duration_len = 4;

reserved_bin = fliplr(de2bi(0,radio_device_status_ie.reserved_len)); 
status_flag_bin = fliplr(de2bi(double(status_flag),radio_device_status_ie.status_flag_len)); 
duration_bin = fliplr(de2bi(double(duration),radio_device_status_ie.duration_len)); 

msg_bin = [reserved_bin status_flag_bin duration_bin];

% ie type defines the length of the ie payload
% type c) without length indication
ie_type = [0 0 0 0 1];
mac_extension_field_encoding = [1 1];
payload_length = 1;
mac_mux_pdu = [mac_extension_field_encoding payload_length ie_type];

% adding the header to the binary data
% len = length(msg_bin);
% len_bin = fliplr(de2bi(len,8));
% msg_bin = [mac_mux_pdu len_bin msg_bin];
msg_bin = [mac_mux_pdu msg_bin];
end