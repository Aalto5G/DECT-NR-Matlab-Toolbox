%
% Extracts structures from the received packet
%

% Kalle Ruttik
% 22.11.2023

function [out_structs] = mac_SDU_parser(rx_mac_sdus)

out_structs = [];
[sdu_struct] = mac_SDUs_extraction(rx_mac_sdus); % {nr} {type} {length} {bits}

sdu_len = length(sdu_struct); % how many sdus
for i1 = 1:sdu_len
%  ie_mac_ext = sdu_struct{i1}{1}{1};
  ie_type = sdu_struct{i1}{1}{2};
  ie_len = sdu_struct{i1}{1}{3};
  ie_sdu = sdu_struct{i1}{1}{4};

  switch ie_type
    case 0
      disp('Padding IE')

    case 1
      disp('Higher layer signalling - flow 1 ')
      disp('Not implemented')
    case 2
      disp('Higher layer signalling - flow 2 ')
      disp('Not implemented')
    case 3
      disp('User plane data - flow 1')
      [rx_user_plane_data_flow_message_ie] = user_plane_data_flow_ie_parser(ie_sdu,ie_len)
    case 4
      disp('User plane data - flow 2')
      [rx_user_plane_data_flow_message_ie] = user_plane_data_flow_ie_parser(ie_sdu,ie_len)
    case 5
      disp('User plane data - flow 3')
      [rx_user_plane_data_flow_message_ie] = user_plane_data_flow_ie_parser(ie_sdu,ie_len)
    case 6
      disp('User plane data - flow 4')
      [rx_user_plane_data_flow_message_ie] = user_plane_data_flow_ie_parser(ie_sdu,ie_len)
    case 7
      disp('Reserved')
      disp('Not implemented')
    case 8
      disp('Network Beackon message')
      [rx_network_beacon_message_ie] = network_beacon_message_ie_parser(ie_sdu)
    case 9
      disp('Cluster Beackon message')
      [rx_cluster_beacon_message_ie] = cluster_beacon_message_ie_parser(ie_sdu)
    case 10
      disp('Association Request message')
      [association_request_msg_ie] = association_request_message_ie_parser(ie_sdu,ie_len)
    case 11
      disp('Association Response message')
      [association_response_msg_ie] = association_response_message_ie_parser(ie_sdu,ie_len)
    case 12
      disp('Association Release message')
      [association_release_message_ie] = association_release_message_ie_parser(rx_msg_sdu,ie_len)
    case 13
      disp('Reconfiguration Request message')
      disp('Not implemented')
    case 14
      disp('Reconfiguration Response message')
      disp('Not implemented')
    case 15
      disp('Additional MAC messages')
      disp('Not implemented')
    case 16
      disp('Security info IE')
      disp('Not implemented')
    case 17
      disp('Route info IE')
      disp('Not implemented')
    case 18
      disp('Resource allocation IE')
      [resource_allocation_ie] = resource_allocation_ie_parser(rx_msg_sdu,ie_len)
    case 19
      disp('Random Access Resource IE')
      [rx_random_access_resource_msg_ie] = random_access_resource_ie_parser(ie_sdu)
    case 20
      disp('RD capability IE')
     [rd_capability_msg_ie] = rd_capability_ie_parser(ie_sdu,ie_len)
    case 21
      disp('Neighbouring IE')
      disp('Not implemented')
    case 22
      disp('Broadcast Indication IE')
      disp('Not implemented')
    case 23
      disp('Group Assignment IE')
      disp('Not implemented')
    case 24
      disp('Load info IE')
      disp('Not implemented')
    case 25
      disp('Measurement Report IE')
      disp('Not implemented')
    case {26:61}
      disp('Reserved')
    case 62
      disp('Escape')
      disp('Not implemented')
    case 63
      disp('IE type extension. Additional byte for IE type')
      disp('Not implemented')
    otherwise
      disp('Error ')
  end


end