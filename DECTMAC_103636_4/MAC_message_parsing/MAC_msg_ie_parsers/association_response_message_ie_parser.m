%
% association_response_message_ie_ie_parser
%

% Kalle Ruttik
% 30.10.2023

function [ association_response_message_ie_struct] = association_response_message_ie_parser(rx_msg_sdu,ie_len)


association_response_msg.ack_nack_len = 1;
association_response_msg.HARQ_mod_len = 1;
association_response_msg.Number_of_flows_len = 3;
association_response_msg.Group_len = 1;
association_response_msg.Tx_power_len = 1;
association_response_msg.Reject_cause_len = 4;
association_response_msg.Reject_time_len = 4;
association_response_msg.HARQ_processes_RX_len = 3;
association_response_msg.MAX_HARQ_Re_RX_len = 5;
association_response_msg.HARQ_processes_TX_len = 3;
association_response_msg.MAX_HARQ_Re_TX_len = 5;
association_response_msg.Flow_ID_len = 6;
association_response_msg.group_ID_len = 7;
association_response_msg.Resource_tag_len = 7;

loc = 0;
association_response_message_ie_struct.ack_nack = rx_msg_sdu(1);
association_response_message_ie_struct.HARQ_mod = rx_msg_sdu(3);
association_response_message_ie_struct.Number_of_flows = bi2de(fliplr(rx_msg_sdu([4:6]))); 
association_response_message_ie_struct.Group = rx_msg_sdu(7);
association_response_message_ie_struct.Tx_power = rx_msg_sdu(8); loc = loc + 8;

if association_response_message_ie_struct.ack_nack == 0
  association_response_message_ie_struct.Reject_cause = bi2de(fliplr(rx_msg_sdu(loc + [1:4])));
  association_response_message_ie_struct.Reject_time = bi2de(fliplr(rx_msg_sdu(loc + [5:8]))); loc = loc +8;
end

% accepted 
if association_response_message_ie_struct.HARQ_mod == 1
  association_response_message_ie_struct.HARQ_processes_RX = bi2de(fliplr(rx_msg_sdu(loc + [1:3])));
  association_response_message_ie_struct.MAX_HARQ_Re_RX = bi2de(fliplr(rx_msg_sdu(loc + [4:8]))); loc = loc +8;
  association_response_message_ie_struct.HARQ_processes_TX = bi2de(fliplr(rx_msg_sdu(loc + [1:3])));
  association_response_message_ie_struct.MAX_HARQ_Re_TX = bi2de(fliplr(rx_msg_sdu(loc + [4:8]))); loc = loc +8;
end

if association_response_message_ie_struct.ack_nack == 1
  association_response_message_ie_struct.Flow_ID = bi2de(fliplr(rx_msg_sdu(loc + [3:8]))); loc = loc +8; 
end

if association_response_message_ie_struct.Group == 1
  association_response_message_ie_struct.group_ID = bi2de(fliplr(rx_msg_sdu(loc + [2:8]))); loc = loc +8; 
end

if association_response_message_ie_struct.ack_nack == 1
  association_response_message_ie_struct.Resource_tag = bi2de(fliplr(rx_msg_sdu(loc + [2:8])));
end

end
