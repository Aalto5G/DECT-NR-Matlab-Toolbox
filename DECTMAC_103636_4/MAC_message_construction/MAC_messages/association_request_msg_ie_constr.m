%
% association request message ie constrcution
%

% Kalle Ruttik
% 26.10.2023

function [msg_bin] =association_request_msg_ie_constr(setup_cause,number_of_flows,Power_const, FT_mode, Current, HARQ_process_TX, MAX_HARQ_Re_TX, HARQ_process_RX, MAX_HARQ_Re_RX,...
  Flow_ID, network_beacon_period, cluster_beacon_period, next_cluster_channel, time_to_next, current_cluster_channel)

% ie type defines the length of the ie payload
% type c) without length indication
ie_type = [0 0 1 0 1 0];
mac_extension_field_encoding = [0 1];
mac_mux_pdu = [mac_extension_field_encoding ie_type];


% clear all
% 
% setup_cause = 3;
% number_of_flows = 3;
% Power_const = 1;
% FT_mode = 1;
% Current = 1;
% HARQ_process_TX = 3;
% MAX_HARQ_Re_TX = 5;
% HARQ_process_RX = 3;
% MAX_HARQ_Re_RX = 5;
% Flow_ID = 6;
% network_beacon_period = 4;
% cluster_beacon_period = 4;
% next_cluster_channel = 13;
% time_to_next = 13;
% current_cluster_channel = 13;

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

%% binary generation
setup_cause_bin = fliplr(de2bi(double(setup_cause),association_request_message.setup_cause_len));
number_of_flows_bin =  fliplr(de2bi(double(number_of_flows),association_request_message.number_of_flows_len));
Power_const_bin =  fliplr(de2bi(double(Power_const),association_request_message.Power_const_len));
FT_mode_bin =  fliplr(de2bi(double(FT_mode),association_request_message.FT_mode_len));
Current_bin =  fliplr(de2bi(double(Current),association_request_message.Current_len));
reserved_bin = de2bi(0,7);
HARQ_process_TX_bin =  fliplr(de2bi(double(HARQ_process_TX),association_request_message.HARQ_process_TX_len));
MAX_HARQ_Re_TX_bin =  fliplr(de2bi(double(MAX_HARQ_Re_TX),association_request_message.MAX_HARQ_Re_TX_len));
HARQ_process_RX_bin =  fliplr(de2bi(double(HARQ_process_RX),association_request_message.HARQ_process_RX_len));
MAX_HARQ_Re_RX_bin =  fliplr(de2bi(double(MAX_HARQ_Re_RX),association_request_message.MAX_HARQ_Re_RX_len));
reserved2_bin = de2bi(0,2);
Flow_ID_bin =  fliplr(de2bi(double(Flow_ID),association_request_message.Flow_ID_len));
network_beacon_period_bin =  fliplr(de2bi(double(network_beacon_period),association_request_message.network_beacon_period_len));
cluster_beacon_period_bin =  fliplr(de2bi(double(cluster_beacon_period),association_request_message.cluster_beacon_period_len));
reserved3_bin = de2bi(0,3);
next_cluster_channel_bin =  fliplr(de2bi(double(next_cluster_channel),association_request_message.next_cluster_channel_len));
time_to_next_bin =  fliplr(de2bi(double(time_to_next),association_request_message.time_to_next_len));
reserved4_bin = de2bi(0,3);
current_cluster_channel_bin =  fliplr(de2bi(double(current_cluster_channel),association_request_message.current_cluster_channel_len));

msg_bin = [setup_cause_bin number_of_flows_bin Power_const_bin FT_mode_bin ...
  Current_bin reserved_bin HARQ_process_TX_bin MAX_HARQ_Re_TX_bin HARQ_process_RX_bin MAX_HARQ_Re_RX_bin ...
  reserved2_bin Flow_ID_bin network_beacon_period_bin cluster_beacon_period_bin ...
  reserved3_bin next_cluster_channel_bin time_to_next_bin reserved4_bin current_cluster_channel_bin];

% adding the header to the binary data
len = length(msg_bin);
len_bin = fliplr(de2bi(len,8));
msg_bin = [mac_mux_pdu len_bin msg_bin];

end
