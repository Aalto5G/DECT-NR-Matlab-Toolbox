%
% MAC MUX Header Option a)
%

% Jaakko Niemistö
% 26.03.2024

function[msg_bin] = mac_mux_header_a_constr( MAC_Ext, length, IE_type_bin)

mux_a.MAC_ext_len   = 2;
mux_a.length_len    = 1;

%% generate binary
MAC_Ext_bin = fliplr(de2bi(double(MAC_Ext),mux_a.MAC_ext_len));
length_bin  = fliplr(de2bi(double(length),mux_a.length_len));

msg_bin = [MAC_Ext_bin length_bin IE_type_bin];

end