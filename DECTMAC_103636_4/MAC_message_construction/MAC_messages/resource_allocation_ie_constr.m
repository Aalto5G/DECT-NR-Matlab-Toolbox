%
% resource allocation ie construction
%

% Kalle Ruttik
% 30.10.2023
% Modified by Simo Hakanummi
% 09.05.2024
% Modified by Jaakko Niemistö
% 13.05.2024

function [msg_bin] = resource_allocation_ie_constr(...
    allocation_type, add_flag, id, repeat, sfn,...
    channel_flag, rlf, start_subslot_1,...
    length_type_1, length_1, start_subslot_2,...
    length_type_2, length_2, short_rd_id,...
    repetition, validity, sfn_value, channel,...
    dect_scheduled_resource_failure)

allocation_type_len = 2;
add_flag_len = 1; 
id_len = 1; 
repeat_len = 3; 
sfn_len = 1; 
channel_flag_len = 1; 
rlf_len = 1;  
start_subslot_1_len = 8;
length_type_1_len = 1;
length_1_len = 7; 
start_subslot_2_len = 8;
length_type_2_len = 1;
length_2_len = 7;
short_rd_id_len = 16; 
repetition_len = 8; 
validity_len = 8;
sfn_value_len = 8; 
channel_len = 13;
dect_scheduled_resource_failure_len = 4;

allocation_type_bin = fliplr(de2bi(double(allocation_type),allocation_type_len));
add_flag_bin = fliplr(de2bi(double(add_flag),add_flag_len));
id_bin = fliplr(de2bi(double(id),id_len));
repeat_bin = fliplr(de2bi(double(repeat),repeat_len)); 
sfn_bin = fliplr(de2bi(double(sfn),sfn_len)); 
channel_flag_bin = fliplr(de2bi(double(channel_flag),channel_flag_len));
rlf_bin = fliplr(de2bi(double(rlf),rlf_len));
reserved1_bin  = fliplr(de2bi(double(0),6));
start_subslot_1_bin = fliplr(de2bi(double(start_subslot_1),start_subslot_1_len));
length_type_1_bin = fliplr(de2bi(double(length_type_1),length_type_1_len));
length_1_bin = fliplr(de2bi(double(length_1),length_1_len));
start_subslot2_bin = fliplr(de2bi(double(start_subslot_2),start_subslot_2_len));
length_type_2_bin = fliplr(de2bi(double(length_type_2),length_type_2_len));
length_2_bin = fliplr(de2bi(double(length_2),length_2_len));

msg_bin = [allocation_type_bin add_flag_bin id_bin repeat_bin sfn_bin channel_flag_bin rlf_bin reserved1_bin ...
  start_subslot_1_bin length_type_1_bin length_1_bin start_subslot2_bin length_type_2_bin length_2_bin];

if id == 1
    short_rc_id_bin = fliplr(de2bi(double(short_rd_id),short_rd_id_len));
    msg_bin = [msg_bin short_rc_id_bin];
end

if repeat > 0
    repetition_bin = fliplr(de2bi(double(repetition),repetition_len)); 
    validity_bin = fliplr(de2bi(double(validity),validity_len)); 
    msg_bin = [msg_bin repetition_bin validity_bin];
end

if sfn == 1
    sfn_value_bin = fliplr(de2bi(double(sfn_value),sfn_value_len)); 
    msg_bin = [msg_bin sfn_value_bin];
end

if channel_flag == 1
    reserved2_bin  = fliplr(de2bi(double(0),3));
    channel_bin = fliplr(de2bi(double(channel),channel_len)); 
    msg_bin = [msg_bin reserved2_bin channel_bin];
end

if rlf == 1
    reserved3_bin = fliplr(de2bi(double(0),4));
    dect_scheduled_resource_failure_bin = fliplr(de2bi(double(dect_scheduled_resource_failure),dect_scheduled_resource_failure_len));
    msg_bin = [msg_bin reserved3_bin dect_scheduled_resource_failure_bin];
end

% adding the header to the binary data
ie_type = [0 1 0 0 1 0];
len = length(msg_bin);
mac_mux_pdu = mac_mux_header_d_constr(ie_type, len);
msg_bin = [mac_mux_pdu msg_bin];

% allocation_type,
% add, 
% id, 
% repeat, 
% sfn, 
% Channel_1, 
% rlf, 
% start_subslot,
% length_type,
% length,
% start_subslot2,
% length_type2,
% length2,
% short_rc_id,
% repetition, 
% validity, 
% sfn_offset, 
% channel1, 
% dectScheduledResourceFailure

end