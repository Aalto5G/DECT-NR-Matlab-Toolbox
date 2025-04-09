%
% Parses the DATA_MAC_PDU_Header
%

% Kalle Ruttik
% 25.10.2023

function [ Reset, sequence_number] = mac_Common_Header_DATA_MAC_PDU_Header_extr(rx_mac_packet)

DATA_MAC_PDU_header_struct.Reset_len          = 1;
DATA_MAC_PDU_header_struct.sequence_number_len    = 12;

Reset = bi2de(fliplr(rx_mac_packet(3+DATA_MAC_PDU_header_struct.Reset_len)));
sequence_number = bi2de(fliplr(rx_mac_packet(3+DATA_MAC_PDU_header_struct.Reset_len+[1:DATA_MAC_PDU_header_struct.sequence_number_len])));

end
