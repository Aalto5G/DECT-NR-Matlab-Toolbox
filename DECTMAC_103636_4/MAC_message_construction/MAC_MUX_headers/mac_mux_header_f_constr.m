%
% MAC MUX Header Option f)
%

% Jaakko Niemistö
% 26.03.2024

function[msg_bin] = mac_mux_header_f_constr( MAC_Ext, IE_type_bin, length, IE_type_extension )

errID = 'mac_mux_header_f:invalid_MAC_Ext_Exception';
errMsg = 'MAC_Ext should be 1 (1 byte) or 2 (2 bytes)';
MAC_Ext_Exception = MException(errID,errMsg);

mux_f.MAC_ext_len       = 2;
if MAC_Ext == 1
    mux_f.length_len    = 8;
elseif MAC_Ext == 2
    mux_f.length_len    = 16;
else
    throw(MAC_Ext_Exception);
end
mux_f.IE_type_extension = 8;

%% generate binary
MAC_Ext_bin             = fliplr(de2bi(double(MAC_Ext),mux_f.MAC_ext_len));
length_bin              = fliplr(de2bi(double(length),mux_f.length_len));
IE_type_extension_bin   = fliplr(de2bi(double(IE_type_extension),mux_f.IE_type_extension));

msg_bin = [MAC_Ext_bin IE_type_bin length_bin IE_type_extension_bin];

end