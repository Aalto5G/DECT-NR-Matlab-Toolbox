%
% MAC MUX Header Option d)
%

% Jaakko Niemistö
% 26.03.2024

function[msg_bin] = mac_mux_header_d_constr( IE_type_bin, length )

mux_d.length_len    = 8;

%% generate binary
MAC_Ext_bin = [0 1];
length_bin  = fliplr(de2bi(double(length),mux_d.length_len));

msg_bin = [MAC_Ext_bin IE_type_bin length_bin ];

end