%
% network_becacon_message_ie_parser
%

% Kalle Ruttik
% 30.10.2023

function [ rd_capability_message_ie_struct] = rd_capability_ie_parser(rx_msg_sdu,ie_len)

loc = 0;
rd_capability_message_ie_struct.number_of_phy_capabilities =   bi2de(fliplr(rx_msg_sdu([1:3])));
rd_capability_message_ie_struct.release = bi2de(fliplr(rx_msg_sdu([4:8]))); loc = loc+8;
rd_capability_message_ie_struct.operating_modes = bi2de(fliplr(rx_msg_sdu(loc+[5:6])));
rd_capability_message_ie_struct.mesh = bi2de(fliplr(rx_msg_sdu(loc+[7])));
rd_capability_message_ie_struct.schedul = bi2de(fliplr(rx_msg_sdu(loc +8))); loc = loc +8;

rd_capability_message_ie_struct.mac_security = bi2de(fliplr(rx_msg_sdu(loc + [1:3])));
rd_capability_message_ie_struct.dlc_service_type = bi2de(fliplr(rx_msg_sdu(loc +[4:6]))); loc = loc +8;

rd_capability_message_ie_struct.rd_power_class = bi2de(fliplr(rx_msg_sdu(loc + [2:4]))); 
rd_capability_message_ie_struct.max_nss_for_rx = bi2de(fliplr(rx_msg_sdu(loc + [5:6])));
rd_capability_message_ie_struct.rx_for_tx_diversity = bi2de(fliplr(rx_msg_sdu(loc + [7:8]))); loc = loc +8;

rd_capability_message_ie_struct.rx_gain = bi2de(fliplr(rx_msg_sdu(loc + [1:4])));
rd_capability_message_ie_struct.max_mcs = bi2de(fliplr(rx_msg_sdu(loc + [5:8]))); loc = loc +8;

rd_capability_message_ie_struct.soft_buffer_size = bi2de(fliplr(rx_msg_sdu(loc + [1:4])));
rd_capability_message_ie_struct.num_of_HARQ_processes = bi2de(fliplr(rx_msg_sdu(loc + [5:6]))); loc = loc +8;


rd_capability_message_ie_struct.HARQ_feedback_delay = bi2de(fliplr(rx_msg_sdu(loc + [1:4]))); loc = loc +8;

rd_capability_message_ie_struct.radio_device_class_mu = bi2de(fliplr(rx_msg_sdu(loc + [1:3])));
rd_capability_message_ie_struct.radio_device_class_beta = bi2de(fliplr(rx_msg_sdu(loc + [4:7]))); loc = loc +8;

rd_capability_message_ie_struct.rd_power_class2 = bi2de(fliplr(rx_msg_sdu(loc + [2:4])));
rd_capability_message_ie_struct.max_nss_for_rx2 = bi2de(fliplr(rx_msg_sdu(loc + [5:6])));
rd_capability_message_ie_struct.rx_for_tx_diversity2 = bi2de(fliplr(rx_msg_sdu(loc + [7:8]))); loc = loc +8;

rd_capability_message_ie_struct.rx_gain2 = bi2de(fliplr(rx_msg_sdu(loc + [1:4])));
rd_capability_message_ie_struct.max_mcs2 = bi2de(fliplr(rx_msg_sdu(loc + [5:8]))); loc = loc +8;

rd_capability_message_ie_struct.soft_buffer_size2 = bi2de(fliplr(rx_msg_sdu(loc + [1:4])));
rd_capability_message_ie_struct.num_of_HARQ_processes2 = bi2de(fliplr(rx_msg_sdu(loc + [5:6]))); loc = loc +8;

rd_capability_message_ie_struct.HARQ_feedback_delay2 = bi2de(fliplr(rx_msg_sdu(loc + [1:4])));

end
