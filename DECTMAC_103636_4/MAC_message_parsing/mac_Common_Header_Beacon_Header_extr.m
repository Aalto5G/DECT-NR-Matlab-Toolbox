%
% Parses the Beacon header from hex numbers into struct 
%

% Kalle Ruttik
% 25.10.2023

function [ network_id, transmitter_address] = mac_Common_Header_Beacon_Header_extr(rx_mac_packet)

Beacon_header_struct.network_id_len          = 24;
Beacon_header_strcut.transmitter_address_len  = 32;

network_id = bi2de(fliplr(rx_mac_packet(1:Beacon_header_struct.network_id_len)));
transmitter_address = bi2de(fliplr(rx_mac_packet(Beacon_header_struct.network_id_len+[1:Beacon_header_strcut.transmitter_address_len])));

end

% h11 = [0 0 1 1 1 0 0 0];
% h12 = [0 0 0 0 0 0 0 0];
% h13 = [0 0 0 0 0 0 0 0];
% h14 = [0 0 0 0 0 0 0 0];
% h15 = [0 0 0 0 0 0 0 0];
% h16 = [0 0 0 0 0 0 0 0];
% h17 = [0 0 0 0 0 0 0 0];
% 
% h11_8 = uint8(bi2de(h11));
% h12_8 = uint8(bi2de(h12));
% h13_8 = uint8(bi2de(h13));
% h14_8 = uint8(bi2de(h14));
% h15_8 = uint8(bi2de(h15));
% h16_8 = uint8(bi2de(h16));
% h17_8 = uint8(bi2de(h17));
% 
% h1 = [h11_8 h12_8 h13_8 h14_8 h15_8 h16_8 h17_8];
% 
% bytes_in = de2bi(double(h1),8)
% 
% % h1 = uint8(bi2de(fliplr(tmpData)))
% 
% tmp_network_id_bin = [bytes_in(1,:) bytes_in(2,:) bytes_in(3,:)];
% tmp_network_id_dec = bi2de(fliplr(tmp_network_id_bin));
% tmp_transmitter_address_bin = [bytes_in(4,:) bytes_in(5,:) bytes_in(6,:) bytes_in(7,:)];
% tmp_transmitter_address_dec = bi2de(fliplr(tmp_transmitter_address_bin));
% 
% Beacon_header.network_id              = tmp_network_id_dec;
% Beacon_header.netwrok_id_len          = 24;
% Beacon_header.transmitter_address      = tmp_transmitter_address_dec;
% Beacon_header.transmitter_address_len  = 32;
% 
