%
% Padding IE message construction
%

% Jaakko Niemistö
% 5.4.2024


function [msg_bin] = padding_ie_msg_constr(octets_n)

% padding ie type
ie_type_b = [0 0 0 0 0];
ie_type_d = [0 0 0 0 0 0];

if octets_n == 1
    % Header type b)
    mac_mux_pdu = mac_mux_header_b_constr(3, 0, ie_type_b);
elseif octets_n == 2
    % Header type b)
    mac_mux_pdu = mac_mux_header_b_constr(3, 1, ie_type_b);
else
    % Header type d)
    mac_mux_pdu = mac_mux_header_d_constr(ie_type_d, octets_n);
end

padding_bin = fliplr(de2bi(double(0),octets_n));

msg_bin = [mac_mux_pdu padding_bin];

end 