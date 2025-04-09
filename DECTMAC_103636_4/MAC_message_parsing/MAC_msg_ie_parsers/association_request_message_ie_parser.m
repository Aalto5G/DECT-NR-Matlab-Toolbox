%
% association request message parser
%

% Kalle Ruttik
% 30.10.2023

function [ association_request_message_ie_struct] = association_request_message_ie_parser(rx_msg_sdu,ie_len)


association_request_message.setup_cause_len = 3;
association_request_message.number_of_flows_len = 3;
association_request_message.Power_const_len = 1;
association_request_message.FT_mode_len = 1;
association_request_message.Current_len = 1;
association_request_message.HARQ_process_TX_len = 3;
association_request_message.MAX_HARQ_Re_TX_len = 5;
association_request_message.HARQ_process_RX_len = 3;
association_request_message.MAX_HARQ_Re_RX_len = 5;
association_request_message.Flow_ID_len = 6;
association_request_message.network_beacon_period_len = 4;
association_request_message.cluster_beacon_period_len = 4;
association_request_message.next_cluster_channel_len = 13;
association_request_message.time_to_next_len = 32;
association_request_message.current_cluster_channel_len = 13;

%% parsing
loc = 0;
association_request_message_ie_struct.setup_cause = bi2de(fliplr(rx_msg_sdu([1:3]))); 
association_request_message_ie_struct.number_of_flows = bi2de(fliplr(rx_msg_sdu([4:6]))); 
association_request_message_ie_struct.Power_const = bi2de(fliplr(rx_msg_sdu([7]))); 
association_request_message_ie_struct.FT_mode = bi2de(fliplr(rx_msg_sdu([8])));    loc = loc + 8;


association_request_message_ie_struct.Current = bi2de(fliplr(rx_msg_sdu(loc + [1]))); 
%association_request_message_ie_struct.Reserved = bi2de(fliplr(rx_msg_sdu(loc +[2:8]))); 
                                                                                   loc = loc + 8;
association_request_message_ie_struct.HARQ_process_TX = bi2de(fliplr(rx_msg_sdu(loc + [1:3]))); 
association_request_message_ie_struct.MAX_HARQ_Re_TX = bi2de(fliplr(rx_msg_sdu(loc + [4:8]))); loc = loc +8;
association_request_message_ie_struct.HARQ_process_RX = bi2de(fliplr(rx_msg_sdu(loc + [1:3]))); 
association_request_message_ie_struct.MAX_HARQ_Re_RX = bi2de(fliplr(rx_msg_sdu(loc + [4:8]))); loc = loc +8;

association_request_message_ie_struct.Flow_ID = bi2de(fliplr(rx_msg_sdu(loc + [3:8]))); loc = loc +8;

association_request_message_ie_struct.network_beacon_period = bi2de(fliplr(rx_msg_sdu(loc + [1:4])));
association_request_message_ie_struct.cluster_beacon_period = bi2de(fliplr(rx_msg_sdu(loc + [5:8]))); loc = loc +8;

association_request_message_ie_struct.next_cluster_channel = bi2de(fliplr(rx_msg_sdu(loc + [4:16]))); loc = loc +16;

association_request_message_ie_struct.time_to_next = bi2de(fliplr(rx_msg_sdu(loc + [1:32]))); loc = loc +32;

association_request_message_ie_struct.current_cluster_channel = bi2de(fliplr(rx_msg_sdu(loc + [4:16])));

end