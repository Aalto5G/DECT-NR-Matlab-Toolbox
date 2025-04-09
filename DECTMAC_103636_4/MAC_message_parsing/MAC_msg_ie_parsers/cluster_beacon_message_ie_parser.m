%
% network_becacon_message_ie_parser
%

% Kalle Ruttik
% 29.10.2023

function [cluster_beacon_message_ie_struct] = cluster_beacon_message_ie_parser(rx_msg_sdu,ie_len)

cluster_beacon_msg_struct.sfn_len = 8;
cluster_beacon_msg_struct.Tx_power_len = 1;
cluster_beacon_msg_struct.Power_const_len = 1;
cluster_beacon_msg_struct.fo_len = 1;
cluster_beacon_msg_struct.next_channel_len = 1;
cluster_beacon_msg_struct.TimeToNext_len = 1;
cluster_beacon_msg_struct.network_beacon_period_len = 4;
cluster_beacon_msg_struct.cluster_beacon_period_len = 4;
cluster_beacon_msg_struct.count_to_trigger_len = 4;
cluster_beacon_msg_struct.rel_quality_len = 2;
cluster_beacon_msg_struct.min_quality_len = 2;
cluster_beacon_msg_struct.cluster_max_tx_power_len = 4;
cluster_beacon_msg_struct.frame_offset_len = 8;
cluster_beacon_msg_struct.next_cluster_channel_len = 13;
cluster_beacon_msg_struct.time_to_next_len = 32;

loc = 0;
cluster_beacon_message_ie_struct.sfn =  bi2de(fliplr(rx_msg_sdu([1:8]))); loc = loc + 8;

cluster_beacon_message_ie_struct.Tx_power = rx_msg_sdu(loc+4);
cluster_beacon_message_ie_struct.Power_const = rx_msg_sdu(loc+5);
cluster_beacon_message_ie_struct.fo = rx_msg_sdu(loc+6);
cluster_beacon_message_ie_struct.next_channel = rx_msg_sdu(loc+7);
cluster_beacon_message_ie_struct.TimeToNext = rx_msg_sdu(loc+8); loc = loc + 8;

cluster_beacon_message_ie_struct.network_beacon_period = bi2de(fliplr(rx_msg_sdu(loc+[1:4])));
cluster_beacon_message_ie_struct.cluster_beacon_period = bi2de(fliplr(rx_msg_sdu(loc+[5:8]))); loc = loc + 8;

cluster_beacon_message_ie_struct.count_to_trigger = bi2de(fliplr(rx_msg_sdu(loc+[1:4])));
cluster_beacon_message_ie_struct.rel_quality = bi2de(fliplr(rx_msg_sdu(loc+[5:6])));
cluster_beacon_message_ie_struct.min_quality = bi2de(fliplr(rx_msg_sdu(loc+[7:8]))); loc = loc + 8;

if cluster_beacon_message_ie_struct.Tx_power == 1
%cluster_beacon_message_ie_struct.reserved = bi2de(fliplr(rx_msg_sdu(loc+[1:4])));
cluster_beacon_message_ie_struct.cluster_max_tx_power = bi2de(fliplr(rx_msg_sdu(loc+[5:8]))); loc = loc + 8;
end

if cluster_beacon_message_ie_struct.fo == 1
cluster_beacon_message_ie_struct.frame_offset = bi2de(fliplr(rx_msg_sdu(loc+[1:8]))); loc = loc + 8;
end

if cluster_beacon_message_ie_struct.next_channel == 1
cluster_beacon_message_ie_struct.next_cluster_channel = bi2de(fliplr(rx_msg_sdu(loc+[4:16]))); loc = loc + 16;
end

if cluster_beacon_message_ie_struct.TimeToNext == 1
cluster_beacon_message_ie_struct.time_to_next = bi2de(fliplr(rx_msg_sdu(loc+[1:32]))); loc = loc + 32;
end

end