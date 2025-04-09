%
% MAC MUX Header Option e)
%

% Jaakko Niemistö
% 26.03.2024

function[msg_bin] = mac_mux_header_e_constr( IE_type_bin, length )

mux_e.length_len    = 16;

%% generate binary
MAC_Ext_bin = [1 0];
length_bin  = fliplr(de2bi(double(length),mux_e.length_len));

msg_bin = [MAC_Ext_bin IE_type_bin length_bin ];

end