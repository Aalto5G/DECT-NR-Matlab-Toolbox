%
% network_becacon_message_ie_parser
%

% Kalle Ruttik
% 29.10.2023

function [network_beacon_message_ie_struct] = network_beacon_message_ie_parser(rx_msg_sdu,ie_len)

network_beacon_msg_struct.reserved_len = 3;
network_beacon_msg_struct.TX_power_len = 1;
network_beacon_msg_struct.Power_const_len = 1;
network_beacon_msg_struct.current_len = 1;
network_beacon_msg_struct.network_beacon_channels_len = 2;

network_beacon_msg_struct.network_beacon_period_len = 4;
network_beacon_msg_struct.cluster_beacon_period_len = 4;
network_beacon_msg_struct.next_cluster_channel_len = 12;
network_beacon_msg_struct.time_to_next_len = 32;

network_beacon_msg_struct.cluster_max_tx_power_len = 4;
network_beacon_msg_struct.current_cluster_channel_len = 13;
network_beacon_msg_struct.additional_network_beacon_channels_len = 13;

network_beacon_message_ie_struct.TX_power = rx_msg_sdu(4);
network_beacon_message_ie_struct.Power_const = rx_msg_sdu(5);
network_beacon_message_ie_struct.current = rx_msg_sdu(6);
network_beacon_message_ie_struct.network_beacon_channels = bi2de(fliplr(rx_msg_sdu(7:8)));

network_beacon_message_ie_struct.network_beacon_period = bi2de(fliplr(rx_msg_sdu(9:12)));
network_beacon_message_ie_struct.cluster_beacon_period = bi2de(fliplr(rx_msg_sdu(13:16)));

network_beacon_message_ie_struct.next_cluster_channel = bi2de(fliplr(rx_msg_sdu(21:32)));
network_beacon_message_ie_struct.time_to_next = bi2de(fliplr(rx_msg_sdu(33:64)));

if network_beacon_message_ie_struct.TX_power == 1
  network_beacon_message_ie_struct.cluster_max_tx_power = bi2de(fliplr(rx_msg_sdu(69:72)));
end
if network_beacon_message_ie_struct.current == 1
  network_beacon_message_ie_struct.current_cluster_channel = bi2de(fliplr(rx_msg_sdu(76:88)));
end
 
start_loc = 88;
for i1 = 1:network_beacon_message_ie_struct.network_beacon_channels
  tmp_bin = rx_msg_sdu(start_loc + [1:16]);
  network_beacon_message_ie_struct.additional_network_beacon_channels(i1) = bi2de(fliplr(tmp_bin(4:16)));
end

% % ie type defines the length of the ie payload
% % type c) without length indication
% ie_type = [0 0 1 0 0 0];
% max_extension_field_encoding = [0 1];
% mac_mux_pdu = [max_extension_field_encoding ie_type];
% 
% % Tx_power = 0;                % tx_power field included
% % Power_const = 0;             % power constraint 0:no 1:yes
% % Current = 0;                 % current cluster ch same as the next 
% % network_beacon_channels = 0; % number of network beacon channels included at the end of message
% % network_beacon_period = 1;   % period in ms 50 100 500 100 1500 2000 4000
% % cluster_beacon_period = 1;   % cluset beacon transmission period
% % next_cluster_channel = 0;    % the channel where cluster operates in next cluster period
% % time_to_next = 0;            % next cluster period start in micro sec.
% % cluster_max_tx_power = 0;    % 
% % current_cluster_channel = 0; % not included if the same as previous
% % additional_network_beacon_channels = 0; % beackon channel nr
% 
% network_beacon_msg_struct.reserved_len = 3;
% network_beacon_msg_struct.TX_power_len = 1;
% network_beacon_msg_struct.Power_const_len = 1;
% network_beacon_msg_struct.current_len = 1;
% network_beacon_msg_struct.network_beacon_channels_len = 2;
% 
% network_beacon_msg_struct.network_beacon_period_len = 4;
% network_beacon_msg_struct.cluster_beacon_period_len = 4;
% network_beacon_msg_struct.next_cluster_channel_len = 12;
% network_beacon_msg_struct.time_to_next_len = 32;
% 
% network_beacon_msg_struct.cluster_max_tx_power_len = 4;
% network_beacon_msg_struct.current_cluster_channel_len = 13;
% network_beacon_msg_struct.additional_network_beacon_channels_len = 13;
% 
% reserved_bin  = fliplr(de2bi(double(0),3)); % initial reserved bits 
% Tx_power_bin  = fliplr(de2bi(double(Tx_power),network_beacon_msg_struct.TX_power_len));
% Power_const_bin   = fliplr(de2bi(double(Power_const),network_beacon_msg_struct.Power_const_len));
% Current_bin   = fliplr(de2bi(double(Current),network_beacon_msg_struct.current_len));
% network_beacon_channels_bin = fliplr(de2bi(double(network_beacon_channels),network_beacon_msg_struct.network_beacon_channels_len));
% 
% network_beacon_period_bin = fliplr(de2bi(double(network_beacon_period),network_beacon_msg_struct.network_beacon_period_len));
% cluster_beacon_period_bin = fliplr(de2bi(double(cluster_beacon_period),network_beacon_msg_struct.cluster_beacon_period_len));
% 
% reserved2_bin  = de2bi(double(0),4);
% next_cluster_channel_bin = fliplr(de2bi(double(next_cluster_channel),network_beacon_msg_struct.next_cluster_channel_len));
% time_to_next_bin = fliplr(de2bi(double(time_to_next),network_beacon_msg_struct.time_to_next_len));
% 
% % puts in permanent parts
% msg_bin = [reserved_bin Tx_power_bin Power_const_bin Current_bin network_beacon_channels_bin network_beacon_period_bin cluster_beacon_period_bin reserved2_bin next_cluster_channel_bin];
% 
% if Tx_power == 1
% reserved3_bin  = de2bi(double(0),4);
% cluster_max_tx_power_bin = fliplr(de2bi(double(cluster_max_tx_power),network_beackon_msg_struct.cluster_max_tx_power_len));
% msg_bin = [msg_bin reserved3_bin cluster_max_tx_power_bin];
% end
% if Current == 1
% reserved4_bin  = de2bi(double(0),3);
% current_cluster_channel_bin = fliplr(de2bi(double(current_cluster_channel),network_beacon_msg_struct.current_cluster_channel_len));
% msg_bin = [msg_bin reserved4_bin current_cluster_channel_bin];
% end
% 
% for i1 = 1:network_beacon_channels
% % i1
% % add check that there are as many elements as given by index
% reserved5_bin  = de2bi(double(0),3);
% additional_network_beacon_channels_bin = fliplr(de2bi(double(additional_network_beacon_channels(i1,:)),network_beacon_msg_struct.additional_network_beacon_channels_len));
% msg_bin = [msg_bin reserved5_bin additional_network_beacon_channels_bin];
% end
% 
% len = length(msg_bin);
% len_bin = fliplr(de2bi(len,8));
% msg_bin = [mac_mux_pdu len_bin msg_bin];
% 
% 
% % %%%%
% % 
% % network_beackon_msg_struct.reserved = 0;
% % network_beackon_msg_struct.reserved_len = 3;
% % network_beackon_msg_struct.TX_power = Tx_power;
% % network_beackon_msg_struct.TX_power_len = 1;
% % network_beackon_msg_struct.Power_const = Power_const;
% % network_beackon_msg_struct.Power_const_len = 1;
% % network_beackon_msg_struct.current = Current;
% % network_beackon_msg_struct.current_len = 1;
% % network_beackon_msg_struct.network_beackon_channels = network_beacon_channels;
% % network_beackon_msg_struct.network_beackon_channels_len = 2;
% % 
% % network_beackon_msg_struct.network_beacon_period = network_beacon_period;
% % network_beackon_msg_struct.network_beacon_period_len = 4;
% % network_beackon_msg_struct.cluster_beacon_period = cluster_beacon_period;
% % network_beackon_msg_struct.cluster_beacon_period_len = 4;
% % 
% % network_beackon_msg_struct.reserved2 = 0;
% % network_beackon_msg_struct.reserved2_len = 3; 
% % 
% % network_beackon_msg_struct.next_cluster_channel = next_cluster_channel;
% % network_beackon_msg_struct.next_cluster_channel_len = 12;
% % 
% % network_beackon_msg_struct.time_to_next = time_to_next;
% % network_beackon_msg_struct.time_to_next_len = 32;
% % 
% % network_beackon_msg_struct.reserved3 = 0;
% % network_beackon_msg_struct.reserved3_len = 4;
% % network_beackon_msg_struct.cluster_max_tx_power = cluster_max_tx_power;
% % network_beackon_msg_struct.cluster_max_tx_power_len = 4;
% % 
% % network_beackon_msg_struct.reserved4 = 0;
% % network_beackon_msg_struct.reserved4_len = 3;
% % network_beackon_msg_struct.current_cluster_channel = current_cluster_channel;
% % network_beackon_msg_struct.current_cluster_channel_len = 13;
% % 
% % network_beackon_msg_struct.reserved5 = 0;
% % network_beackon_msg_struct.reserved5_len = 3; 
% % network_beackon_msg_struct.additional_network_beacon_channels = additional_network_beacon_channels;
% % network_beackon_msg_struct.additional_network_beacon_channels_len = 13;
% % 
% % %% dec to bits 
% % reserved_bin = de2bi(double(0),network_beackon_msg_struct.reserved_len);
% % Tx_power_bin = de2bi(double(Tx_power),network_beackon_msg_struct.TX_power_len);
% % Power_const_bin = de2bi(double(Power_const),network_beackon_msg_struct.Power_const_len);
% % Current_bin = de2bi(double(Current),network_beackon_msg_struct.current_len);
% % network_beacon_channels_bin = de2bi(double(network_beacon_channels),network_beackon_msg_struct.network_beackon_channels_len);
% % network_beacon_period_bin = de2bi(double(network_beacon_period),network_beackon_msg_struct.network_beacon_period_len);
% % cluster_beacon_period_bin = de2bi(double(cluster_beacon_period),network_beackon_msg_struct.cluster_beacon_period_len);
% % next_cluster_channel_bin = de2bi(double(next_cluster_channel),network_beackon_msg_struct.next_cluster_channel_len);
% % time_to_next_bin = de2bi(double(time_to_next),network_beackon_msg_struct.time_to_next_len);
% % cluster_max_tx_power_bin = de2bi(double(cluster_max_tx_power),network_beackon_msg_struct.cluster_max_tx_power_len);
% % current_cluster_channel_bin = de2bi(double(current_cluster_channel),network_beackon_msg_struct.current_cluster_channel_len);
% % additional_network_beacon_channels_bin = de2bi(double(additional_network_beacon_channels),network_beackon_msg_struct.additional_network_beacon_channels_len);


end