%
% cluster beacon state machine for tracking the message
%

% Kalle Ruttik
% 12.08.2023


cluster_Beackon_ie.SFN = 255; % 8 bti  system frame number
cluster_Beackon_ie.TX_power = 0; % 1 bit
cluster_Beackon_ie.Power_const = 0; % 1 bit
cluster_Beackon_ie.FO = 255; % 0 bit
cluster_Beackon_ie.next_channel = 0; % 1 bit
cluster_Beackon_ie.time_to_next = 0; % 1 bit
cluster_Beackon_ie.network_Beacon_period = 255; % 4 bit 
cluster_Beackon_ie.cluster_Beacon_period = 255; % 4 bit 
cluster_Beackon_ie.count_to_trigger = 255; % 4 bit
cluster_Beackon_ie.rel_quality = 255; % 2 bit 
cluster_Beackon_ie.min_quality = 255; % 2 bit 
cluster_Beackon_ie.cluster_max_tx_power = 255; % 4 bit 
cluster_Beackon_ie.frame_offset = 255; % 8 or 16 bit system frame number
cluster_Beackon_ie.next_cluster_channel = 255; % 13 bit  
cluster_Beackon_ie.tiem_to_next = 255; % 32 bit  


random_Access_Resource_ie.reserver = 0; % 3 bit
random_Access_Resource_ie.repeat = 0;   % 2 bit
random_Access_Resource_ie.sfn = 0;      % 1 bit
random_Access_Resource_ie.channel = 0;  % 1 bit
random_Access_Resource_ie.channel2 = 0;  % 1 bit
random_Access_Resource_ie.start_subslot = 0;  % 16 bit
random_Access_Resource_ie.length_type = 0;  % 1 bit
random_Access_Resource_ie.length      = 0;  % 1 bit
random_Access_Resource_ie.max_length_type = 0;  % 1 bit
random_Access_Resource_ie.max_rach_length = 4;  % 4 bit
random_Access_Resource_ie.cw_min_sig = 4;  % 3 bit
random_Access_Resource_ie.dect_delay = 0;  % 1 bit
random_Access_Resource_ie.response_window = 4;  % 4 bit
random_Access_Resource_ie.cw_max_sig= 4;  % 3 bit
random_Access_Resource_ie.repetition = 0;  % 8 bit
random_Access_Resource_ie.validity = 4;  % 4 bit
random_Access_Resource_ie.sfn_offset = 4;  % 3 bit
random_Access_Resource_ie.reserved = 4;  % 3 bit
random_Access_Resource_ie.channel = 4;  % 13 bit
random_Access_Resource_ie.reserved2 = 4;  % 3 bit
random_Access_Resource_ie.channel2 = 4;  % 13 bit

