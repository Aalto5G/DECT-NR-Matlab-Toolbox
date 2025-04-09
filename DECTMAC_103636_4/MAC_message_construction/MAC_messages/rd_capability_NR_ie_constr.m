%
% rd capability ie construction 
%

% Kalle Ruttik
% 30.10.2023

function [msg_bin] = rd_capability_NR_ie_constr(number_of_radio_device_classes,...
    varargin)

celldisp(varargin)
% ie type defines the length of the ie payload
% type c) without length indication
ie_type = [0 1 0 1 0 0];
mac_extension_field_encoding = [0 1];
mac_mux_pdu = [mac_extension_field_encoding ie_type];

%% lengths 
number_of_radio_device_classes_len = 4;
radio_device_class_mu_len = 3;
radio_device_class_beta_len = 4;
radio_device_class_NSS_len = 3;
radio_device_class_letter_len = 4;


%% binary generation

number_of_radio_device_classes_bin = fliplr(de2bi(double(number_of_radio_device_classes),number_of_radio_device_classes_len));
reserved_bin  = fliplr(de2bi(double(0),4));
msg_bin = [number_of_radio_device_classes_bin reserved_bin];
i = 0;
reserved_repeat_bin  = fliplr(de2bi(double(0),2));
while i < number_of_radio_device_classes
    radio_device_class_mu_bin = fliplr(de2bi(double(varargin{1+(i*4)}),radio_device_class_mu_len));
    radio_device_class_beta_bin = fliplr(de2bi(double(varargin{2+(i*4)}),radio_device_class_beta_len));
    radio_device_class_NSS_bin = fliplr(de2bi(double(varargin{3+(i*4)}),radio_device_class_NSS_len));
    radio_device_class_letter_bin = fliplr(de2bi(double(varargin{4+(i*4)}),radio_device_class_letter_len));
    msg_bin = [msg_bin radio_device_class_mu_bin radio_device_class_beta_bin radio_device_class_NSS_bin radio_device_class_letter_bin reserved_repeat_bin]
    i = i + 1;
end


% adding the header to the binary data

% This solution caused the lua script read to fail, perhaps the binary
% length caused issues? Ask Kalle for clarification.
%len = length(msg_bin);
%len_bin = fliplr(de2bi(len,8));
%msg_bin = [mac_mux_pdu len_bin msg_bin];

% This seems to work for now.
len = length(msg_bin);
mac_mux_pdu = mac_mux_header_d_constr(ie_type, len);
msg_bin = [mac_mux_pdu msg_bin];

end