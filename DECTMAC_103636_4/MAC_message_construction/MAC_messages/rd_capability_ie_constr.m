%
% rd capability ie construction 
%

% Kalle Ruttik
% 30.10.2023

function [msg_bin] = rd_capability_ie_constr(number_of_phy_capabilities,...
    release, groupas, paging,operating_modes, mesh, schedul, mac_security,...
    dlc_service_type, rd_power_class, max_nss_for_rx, rx_for_tx_diversity,...
    rx_gain, max_mcs, soft_buffer_size, num_of_HARQ_processes,...
    HARQ_feedback_delay, d_delay, halfdup, radio_device_class_mu, radio_device_class_beta,...
  rd_power_class2, max_nss_for_rx2, rx_for_tx_diversity2,rx_gain2, max_mcs2,...
  soft_buffer_size2, num_of_HARQ_processes2, HARQ_feedback_delay2 )

% ie type defines the length of the ie payload
% type c) without length indication
ie_type = [0 1 0 1 0 0];
mac_extension_field_encoding = [0 1];
mac_mux_pdu = [mac_extension_field_encoding ie_type];

%% lengths 
number_of_phy_capabilities_len = 3;
release_len = 5;
groupas_len = 1;
paging_len = 1;
operating_modes_len = 2;
mesh_len = 1;
schedul_len = 1;
mac_security_len = 3;
dlc_service_type_len = 3;
rd_power_class_len = 3;
max_nss_for_rx_len = 2;
rx_for_tx_diversity_len = 2;
rx_gain_len = 4;
max_mcs_len = 4;
soft_buffer_size_len = 4;
num_of_HARQ_processes_len = 2;
HARQ_feedback_delay_len = 4;
d_delay_len = 1;
halfdup_len = 1;
radio_device_class_mu_len = 3;
radio_device_class_beta_len = 4;
rd_power_class2_len = 3;
max_nss_for_rx2_len = 2;
rx_for_tx_diversity2_len = 2;
rx_gain2_len = 4;
max_mcs2_len = 4;
soft_buffer_size2_len = 4;
num_of_HARQ_processes2_len = 2;
HARQ_feedback_delay2_len = 4;



%% binary generation

number_of_phy_capabilities_bin = fliplr(de2bi(double(number_of_phy_capabilities),number_of_phy_capabilities_len));
release_bin = fliplr(de2bi(double(release),release_len));
reserved0_bin = zeros(1,2);
groupas_bin = fliplr(de2bi(double(groupas),groupas_len));
paging_bin = fliplr(de2bi(double(paging), paging_len));
operating_modes_bin = fliplr(de2bi(double(operating_modes),operating_modes_len));
mesh_bin = fliplr(de2bi(double(mesh),mesh_len));
schedul_bin = fliplr(de2bi(double(schedul),schedul_len));
mac_security_bin = fliplr(de2bi(double(mac_security),mac_security_len));
dlc_service_type_bin = fliplr(de2bi(double(dlc_service_type),dlc_service_type_len));
reserved_bin = de2bi(0,2);
reserved1_bin = de2bi(0,1);
rd_power_class_bin = fliplr(de2bi(double(rd_power_class),rd_power_class_len));
max_nss_for_rx_bin = fliplr(de2bi(double(max_nss_for_rx),max_nss_for_rx_len));
rx_for_tx_diversity_bin = fliplr(de2bi(double(rx_for_tx_diversity),rx_for_tx_diversity_len));
rx_gain_bin = fliplr(de2bi(double(rx_gain),rx_gain_len));
max_mcs_bin = fliplr(de2bi(double(max_mcs),max_mcs_len));
soft_buffer_size_bin = fliplr(de2bi(double(soft_buffer_size),soft_buffer_size_len));
num_of_HARQ_processes_bin = fliplr(de2bi(double(num_of_HARQ_processes),num_of_HARQ_processes_len));
reserved3_bin = [0 0];
HARQ_feedback_delay_bin = fliplr(de2bi(double(HARQ_feedback_delay),HARQ_feedback_delay_len));
d_delay_bin = fliplr(de2bi(double(d_delay),d_delay_len));
halfdup_bin = fliplr(de2bi(double(halfdup),halfdup_len));
reserved4_bin = de2bi(0,2);
radio_device_class_mu_bin = fliplr(de2bi(double(radio_device_class_mu),radio_device_class_mu_len));
radio_device_class_beta_bin = fliplr(de2bi(double(radio_device_class_beta),radio_device_class_beta_len));
reserved5_bin = 0;
reserved6_bin = de2bi(0,1);
rd_power_class2_bin = fliplr(de2bi(double(rd_power_class2),rd_power_class2_len));
max_nss_for_rx2_bin = fliplr(de2bi(double(max_nss_for_rx2),max_nss_for_rx2_len));
rx_for_tx_diversity2_bin = fliplr(de2bi(double(rx_for_tx_diversity2),rx_for_tx_diversity2_len));
rx_gain2_bin = fliplr(de2bi(double(rx_gain2),rx_gain2_len));
max_mcs2_bin = fliplr(de2bi(double(max_mcs2),max_mcs2_len));
soft_buffer_size2_bin = fliplr(de2bi(double(soft_buffer_size2),soft_buffer_size2_len));
num_of_HARQ_processes2_bin = fliplr(de2bi(double(num_of_HARQ_processes2),num_of_HARQ_processes2_len));
reserved7_bin = de2bi(0,2);
HARQ_feedback_delay2_bin = fliplr(de2bi(double(HARQ_feedback_delay2),HARQ_feedback_delay2_len));
reserved8_bin = de2bi(0,4);

msg_bin = [number_of_phy_capabilities_bin release_bin reserved0_bin groupas_bin paging_bin operating_modes_bin mesh_bin schedul_bin mac_security_bin dlc_service_type_bin reserved_bin ...
  reserved1_bin rd_power_class_bin max_nss_for_rx_bin rx_for_tx_diversity_bin rx_gain_bin max_mcs_bin soft_buffer_size_bin num_of_HARQ_processes_bin reserved3_bin ...
  HARQ_feedback_delay_bin d_delay_bin halfdup_bin reserved4_bin radio_device_class_mu_bin radio_device_class_beta_bin reserved5_bin reserved6_bin rd_power_class2_bin max_nss_for_rx2_bin rx_for_tx_diversity2_bin ...
  rx_gain2_bin max_mcs2_bin soft_buffer_size2_bin num_of_HARQ_processes2_bin reserved7_bin HARQ_feedback_delay2_bin reserved8_bin];


% adding the header to the binary data
len = length(msg_bin);
len_bin = fliplr(de2bi(len,8));
msg_bin = [mac_mux_pdu len_bin msg_bin];

end