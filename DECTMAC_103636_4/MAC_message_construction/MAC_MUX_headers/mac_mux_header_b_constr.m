%
% MAC MUX Header Option b)
%

% Jaakko Niemistö
% 26.03.2024

function[msg_bin] = mac_mux_header_b_constr( MAC_Ext, length, IE_type_bin)

mux_b.MAC_ext_len   = 2;
mux_b.length_len    = 1;

%% generate binary
MAC_Ext_bin = fliplr(de2bi(double(MAC_Ext),mux_b.MAC_ext_len));
length_bin  = fliplr(de2bi(double(length),mux_b.length_len));

msg_bin = [MAC_Ext_bin length_bin IE_type_bin];

end