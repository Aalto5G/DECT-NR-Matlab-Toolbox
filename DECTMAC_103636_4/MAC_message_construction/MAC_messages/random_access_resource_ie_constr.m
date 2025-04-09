%
% random access resource ie constrcution
%

% Kalle Ruttik
% 26.10.2023

function [msg_bin] = random_access_resource_ie_constr(Repeat,SFN,Channel,Channel_2,Start_subslot,Length_type, Length,MAX_len_type,MAX_RACH_Length,CW_min_sig,...
  DECT_delay,response_window,CW_max_sig,repetition,validity,SFN_offset,channel1,channel2)


% ie type defines the length of the ie payload
% type c) without length indication
ie_type = [0 1 0 0 1 1];
mac_extension_field_encoding = [0 1];
mac_mux_pdu = [mac_extension_field_encoding ie_type];

% clear all
% Repeat = 0;
% SFN = 0;
% Channel = 0;
% Channel_2 = 0;
% 
% Start_subslot = 0;
% Length_type = 0;
% Length = 0;
% MAX_len_type = 0;
% MAX_RACH_Length = 0;
% 
% CW_min_sig = 0;
% DECT_delay = 0;
% response_window = 0;
% CW_max_sig = 0;
% repetition = 0;
% validity = 0; 
% SFN_offset = 0;
% channel1 = 0;
% channel2 = 0;

% lengths

random_access_resource_ie_struct.Repeat_len = 2; 
random_access_resource_ie_struct.SFN_len = 1;
random_access_resource_ie_struct.Channel_len = 1;
random_access_resource_ie_struct.Channel_2_len = 1;
random_access_resource_ie_struct.Start_subslot_len = 8;
random_access_resource_ie_struct.Length_type_len = 1;
random_access_resource_ie_struct.Length_len = 7;
random_access_resource_ie_struct.MAX_len_type_len = 1;
random_access_resource_ie_struct.MAX_RACH_length_len = 4;
random_access_resource_ie_struct.CW_min_sig_len = 3;
random_access_resource_ie_struct.DECT_delay_len = 1;
random_access_resource_ie_struct.response_window_len = 4;
random_access_resource_ie_struct.CW_max_sig_len = 3;
random_access_resource_ie_struct.repetition_len = 8;
random_access_resource_ie_struct.validity_len = 8;
random_access_resource_ie_struct.SFN_offset_len = 8;
random_access_resource_ie_struct.Channel1_len = 13;
random_access_resource_ie_struct.Channel2_len = 13;


%% binary creation
reserved_bin = fliplr(de2bi(double(0),3)); % initial reserved bits 
Repeat_bin = fliplr(de2bi(double(Repeat),random_access_resource_ie_struct.Repeat_len));
SFN_bin = fliplr(de2bi(double(SFN),random_access_resource_ie_struct.SFN_len));
Channel_bin = fliplr(de2bi(double(Channel),random_access_resource_ie_struct.Channel_len));
Channel_2_bin = fliplr(de2bi(double(Channel_2),random_access_resource_ie_struct.Channel_2_len));
Start_subslot_bin = fliplr(de2bi(double(Start_subslot),random_access_resource_ie_struct.Start_subslot_len));
Length_type_bin = fliplr(de2bi(double(Length_type),random_access_resource_ie_struct.Length_type_len));
Length_bin = fliplr(de2bi(double(Length),random_access_resource_ie_struct.Length_len));
MAX_len_type_bin = fliplr(de2bi(double(MAX_len_type),random_access_resource_ie_struct.MAX_len_type_len));
MAX_RACH_Length_bin =  fliplr(de2bi(double(MAX_RACH_Length),random_access_resource_ie_struct.MAX_RACH_length_len));
CW_min_sig_bin = fliplr(de2bi(double(CW_min_sig),random_access_resource_ie_struct.CW_min_sig_len));
DECT_delay_bin = fliplr(de2bi(double(DECT_delay),random_access_resource_ie_struct.DECT_delay_len));
response_window_bin = fliplr(de2bi(double(response_window),random_access_resource_ie_struct.response_window_len));
CW_max_sig_bin = fliplr(de2bi(double(CW_max_sig),random_access_resource_ie_struct.CW_max_sig_len));


msg_bin = [reserved_bin Repeat_bin SFN_bin Channel_bin Channel_2_bin Start_subslot_bin Length_type_bin Length_bin MAX_len_type_bin MAX_RACH_Length_bin CW_min_sig_bin DECT_delay_bin response_window_bin CW_max_sig_bin];

if Repeat>0
 repetition_bin = fliplr(de2bi(double(repetition),random_access_resource_ie_struct.repetition_len));
 validity_bin = fliplr(de2bi(double(validity),random_access_resource_ie_struct.validity_len));
 msg_bin = [msg_bin  repetition_bin validity_bin];
end

if SFN == 1
 SFN_offset_bin = fliplr(de2bi(double(SFN_offset),random_access_resource_ie_struct.SFN_offset_len));
 msg_bin = [msg_bin SFN_offset_bin];
end

if Channel == 1
 reserved2_bin = fliplr(de2bi(double(0),3));
 channel1_bin = fliplr(de2bi(double(channel1),random_access_resource_ie_struct.Channel1_len));
 msg_bin = [msg_bin reserved2_bin channel1_bin];
end

if Channel_2 == 1
 reserved3_bin = de2bi(double(0),3);
 channel2_bin = fliplr(de2bi(double(channel2),random_access_resource_ie_struct.Channel2_len));
 msg_bin = [msg_bin reserved3_bin channel2_bin];
end

% adding the header to the binary data
len = length(msg_bin);
len_bin = fliplr(de2bi(len,8));
msg_bin = [mac_mux_pdu len_bin msg_bin];

%len = length(msg_bin);
%mac_mux_pdu = mac_mux_header_d_constr(ie_type, len);
%msg_bin = [mac_mux_pdu msg_bin];

% 
% random_access_resource_ie_struct.reserved = 1;
% random_access_resource_ie_struct.reserved_len = 1;
% random_access_resource_ie_struct.Repeat = 1;
% random_access_resource_ie_struct.Repeat_len = 1; 
% random_access_resource_ie_struct.SFN = 1;
% random_access_resource_ie_struct.SFN_len = 1;
% random_access_resource_ie_struct.Channel = 1;
% random_access_resource_ie_struct.Channel_len = 1;
% random_access_resource_ie_struct.Channel_2 = 1;
% random_access_resource_ie_struct.Channel_2_len = 1;
% random_access_resource_ie_struct.start_subslot = 1;
% random_access_resource_ie_struct.start_subslot_len = 1;
% random_access_resource_ie_struct.length_type = 1;
% random_access_resource_ie_struct.length_type_len = 1;
% random_access_resource_ie_struct.max_length_type = 1;
% random_access_resource_ie_struct.max_length_type_len = 1;
% random_access_resource_ie_struct.max_RACH_length = 1;
% random_access_resource_ie_struct.max_RACH_length_len = 1;
% random_access_resource_ie_struct.CW_min_sig = 1;
% random_access_resource_ie_struct.CW_min_sig_len = 1;
% random_access_resource_ie_struct.DECT_delay = 1;
% random_access_resource_ie_struct.DECT_delay_len = 1;
% random_access_resource_ie_struct.response_window = 1;
% random_access_resource_ie_struct.response_window_len = 1;
% random_access_resource_ie_struct.CW_max_sig = 1;
% random_access_resource_ie_struct.CW_max_sig_len = 1;
% 
% 
% random_access_resource_ie_struct.repetetion = 1;
% random_access_resource_ie_struct.repetition_len = 1;
% random_access_resource_ie_struct.validity = 1;
% random_access_resource_ie_struct.validity_len = 1;
% random_access_resource_ie_struct.SFN_offset = 1;
% random_access_resource_ie_struct.SFN_offset_len = 1;
% 
% random_access_resource_ie_struct.reserved2 = 1;
% random_access_resource_ie_struct.reserved2_len = 1;
% random_access_resource_ie_struct.channel2 = 1;
% random_access_resource_ie_struct.channel2_len = 1;
% 
% random_access_resource_ie_struct.reserved3 = 1;
% random_access_resource_ie_struct.reserved3_len = 1;
% random_access_resource_ie_struct.channel3 = 1;
% random_access_resource_ie_struct.channel3_len = 1;
% 

end
