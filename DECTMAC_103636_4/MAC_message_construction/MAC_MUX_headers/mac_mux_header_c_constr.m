%
% MAC MUX Header Option c)
%

% Jaakko Niemistö
% 26.03.2024

function[msg_bin] = mac_mux_header_c_constr( IE_type_bin )


%% generate binary
MAC_Ext_bin = [0 0];

msg_bin = [MAC_Ext_bin IE_type_bin];

end