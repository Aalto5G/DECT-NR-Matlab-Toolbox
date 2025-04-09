%
% Broadcast Indication IE message construction
%

% Jaakko Niemistö
% 4.4.2024
% Modified by Simo Hakanummi
% 9.5.2024

function [msg_bin] = broadcast_indication_msg_ie_constr(...
    indication_type,id_type,ack_nack,feedback,resource_allocation,...
    long_short_RD_ID, MCS_MIMO_feedback)

% The length of RD_ID is decided with 1 bit, so 0 = Short (16bit) 1 = Long (32bit)
RD_ID_len = 16;
if id_type == 1
    RD_ID_len = 32;
end

broadcast_indication_msg_struct.indication_type = 3;
broadcast_indication_msg_struct.id_type = 1;
broadcast_indication_msg_struct.ack_nack = 1;
broadcast_indication_msg_struct.feedback = 2;
broadcast_indication_msg_struct.resource_allocation = 1;
broadcast_indication_msg_struct.MCS_MIMO_feedback = 8;

indication_type_bin = fliplr(de2bi(double(indication_type),broadcast_indication_msg_struct.indication_type));
id_type_bin = fliplr(de2bi(double(id_type),broadcast_indication_msg_struct.id_type));

msg_bin = [indication_type_bin id_type_bin];

if indication_type == 1
    ack_nack_bin = fliplr(de2bi(double(ack_nack),broadcast_indication_msg_struct.ack_nack));
    feedback_bin = fliplr(de2bi(double(feedback),broadcast_indication_msg_struct.feedback));
    msg_bin = [msg_bin ack_nack_bin feedback_bin];
else
    padding = fliplr(de2bi(double(0),3));
    msg_bin = [msg_bin padding];
end
resource_allocation_bin = fliplr(de2bi(double(resource_allocation),broadcast_indication_msg_struct.resource_allocation));
long_short_RD_ID_bin = fliplr(de2bi(double(long_short_RD_ID),RD_ID_len));
msg_bin = [msg_bin resource_allocation_bin long_short_RD_ID_bin];

if indication_type == 1
    MCS_MIMO_feedback_bin = fliplr(de2bi(double(MCS_MIMO_feedback),broadcast_indication_msg_struct.MCS_MIMO_feedback));
    msg_bin = [msg_bin MCS_MIMO_feedback_bin];
end

% Header type d)
ie_type = [0 1 0 1 1 0]; % broadcast indication message type 
len = length(msg_bin);
mac_mux_pdu = mac_mux_header_d_constr(ie_type, len);

msg_bin = [mac_mux_pdu msg_bin];

end 
