%
% cluster beacon message construction
%

% Kalle Ruttik
% 26.10.2023


function [msg_bin] = cluster_beacon_msg_ie_constr(sfn,Tx_power,Power_const, fo, next_channel, TimeToNext, network_beacon_period, cluster_beacon_period, count_to_trigger, ...
  rel_quality, min_quality, cluster_max_tx_power, frame_offset, next_cluster_channel, time_to_next)

% ie type defines the length of the ie payload
% type c) with length indication
ie_type = [0 0 1 0 0 1]; %cluster beacon message type 
mac_extension_field_encoding = [0 1];
mac_mux_pdu = [mac_extension_field_encoding ie_type];

% sfn = 0;
% Tx_power = 0;
% Power_const = 0;
% fo = 0;
% next_channel = 0;
% TimeToNext = 0;
% 
% network_beacon_period = 0;
% cluster_beacon_period = 0;
% 
% count_to_trigger = 0;
% rel_quality = 0;
% min_quality = 0;
% cluster_max_tx_power = 0;
% frame_offset = 0;
% 
% next_cluster_channel=0;
% time_to_next = 0;

cluster_beacon_msg_struct.sfn_len = 8;
cluster_beacon_msg_struct.TX_power_len = 1;
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

sfn_bin = fliplr(de2bi(double(sfn),cluster_beacon_msg_struct.sfn_len));
reserved_bin  = fliplr(de2bi(double(0),3)); % initial reserved bits 
Tx_power_bin  = fliplr(de2bi(double(Tx_power),cluster_beacon_msg_struct.TX_power_len));
Power_const_bin   = fliplr(de2bi(double(Power_const),cluster_beacon_msg_struct.Power_const_len));
fo_bin   = fliplr(de2bi(double(fo),cluster_beacon_msg_struct.fo_len));
next_channel_bin = fliplr(de2bi(double(next_channel),cluster_beacon_msg_struct.next_channel_len));
TimeToNext_bin = fliplr(de2bi(double(TimeToNext),cluster_beacon_msg_struct.TimeToNext_len));

network_beacon_period_bin = fliplr(de2bi(double(network_beacon_period),cluster_beacon_msg_struct.network_beacon_period_len));
cluster_beacon_period_bin = fliplr(de2bi(double(cluster_beacon_period),cluster_beacon_msg_struct.cluster_beacon_period_len));


count_to_trigger_bin = fliplr(de2bi(double(count_to_trigger),cluster_beacon_msg_struct.count_to_trigger_len));
rel_quality_bin = fliplr(de2bi(double(rel_quality),cluster_beacon_msg_struct.rel_quality_len));
min_quality_bin = fliplr(de2bi(double(min_quality),cluster_beacon_msg_struct.min_quality_len));

msg_bin = [sfn_bin reserved_bin Tx_power_bin Power_const_bin fo_bin next_channel_bin TimeToNext_bin network_beacon_period_bin cluster_beacon_period_bin count_to_trigger_bin rel_quality_bin min_quality_bin];

if Tx_power == 1
reserved2_bin  = de2bi(double(0),4);
cluster_max_tx_power_bin = fliplr(de2bi(double(cluster_max_tx_power),cluster_beacon_msg_struct.cluster_max_tx_power_len));
msg_bin = [msg_bin reserved2_bin cluster_max_tx_power_bin];
end

if fo == 1
frame_offset_bin = fliplr(de2bi(double(frame_offset),cluster_beacon_msg_struct.frame_offset_len));
msg_bin = [msg_bin frame_offset_bin];
end

if next_channel == 1
reserved3_bin  = de2bi(double(0),3);
next_cluster_channel_bin = fliplr(de2bi(double(next_cluster_channel),cluster_beacon_msg_struct.next_cluster_channel_len));
msg_bin = [msg_bin reserved3_bin next_cluster_channel_bin];
end

if TimeToNext == 1
time_to_next_bin = fliplr(de2bi(double(time_to_next),cluster_beacon_msg_struct.time_to_next_len));
msg_bin = [msg_bin time_to_next_bin];
end

% adding the header to the binary data
len = length(msg_bin);
len_bin = fliplr(de2bi(len,8));
msg_bin = [mac_mux_pdu len_bin msg_bin];

% 
% cluster_beackon_msg_struct.reserved = 1;
% cluster_beackon_msg_struct.reserved_len = 1;
% cluster_beackon_msg_struct.TX_power = 1;
% cluster_beackon_msg_struct.TX_power_len = 1; 
% cluster_beackon_msg_struct.Power_const = 1;
% cluster_beackon_msg_struct.Power_const_len = 11;
% cluster_beackon_msg_struct.FO = 1;
% cluster_beackon_msg_struct.FO_len = 1;
% cluster_beackon_msg_struct.Next_channel = 1;
% cluster_beackon_msg_struct.Next_channel_len = 1;
% cluster_beackon_msg_struct.TimeToNext = 1;
% cluster_beackon_msg_struct.TimeToNext_len = 1;
% cluster_beackon_msg_struct.network_beacon_period = 1;
% cluster_beackon_msg_struct.network_beacon_period_len = 1;
% cluster_beackon_msg_struct.cluster_beacon_period = 1;
% cluster_beackon_msg_struct.cluster_beacon_period_len = 1;
% 
% cluster_beackon_msg_struct.count_to_trigger = 1;
% cluster_beackon_msg_struct.count_to_trigger_len = 1;
% cluster_beackon_msg_struct.rel_quality = 1;
% cluster_beackon_msg_struct.rel_quality_len = 1;
% cluster_beackon_msg_struct.min_quality = 1;
% cluster_beackon_msg_struct.min_quality_len = 1;
% 
% cluster_beackon_msg_struct.reserved2 = 1;
% cluster_beackon_msg_struct.reserved2_len = 4;
% cluster_beackon_msg_struct.cluster_max_tx_power = 1;
% cluster_beackon_msg_struct.cluster_max_tx_power_len = 1;
% 
% cluster_beackon_msg_struct.frame_offset = 1;
% cluster_beackon_msg_struct.frame_offset_len = 1;
% 
% cluster_beackon_msg_struct.reserved3 = 1;
% cluster_beackon_msg_struct.reserved3_len = 3;
% 
% cluster_beackon_msg_struct.next_cluster_channel = 1;
% cluster_beackon_msg_struct.next_cluster_channel_len = 13;
% 
% cluster_beackon_msg_struct.time_to_next = 1;
% cluster_beackon_msg_struct.time_to_next_len = 32;

end 

