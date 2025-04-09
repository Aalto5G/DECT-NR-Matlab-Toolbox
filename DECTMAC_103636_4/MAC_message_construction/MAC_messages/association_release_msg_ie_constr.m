%
% association_release_msg construction
%

% Kalle Ruttik
% 27.10.2023

function [msg_bin] = association_release_msg_ie_constr(release_cause)

% ie type defines the length of the ie payload
% type c) without length indication
ie_type = [0 0 1 1 0 0];
mac_extension_field_encoding = [0 0];
mac_mux_pdu = [mac_extension_field_encoding ie_type];

% clear all
% 
% release_cause = 0;
release_cause_len = 4;

release_cause_bin = fliplr(de2bi(double(release_cause),release_cause_len));
reserved_bin = de2bi(0,4);

msg_bin = [release_cause_bin reserved_bin];


% adding the header to the binary data
len = length(msg_bin);
%len_bin = fliplr(de2bi(len,8));
%msg_bin = [mac_mux_pdu len_bin msg_bin];
msg_bin = [mac_mux_pdu msg_bin];
end