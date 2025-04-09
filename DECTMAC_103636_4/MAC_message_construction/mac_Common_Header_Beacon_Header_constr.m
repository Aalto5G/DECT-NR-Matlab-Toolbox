%
% creates a Beacon header from input struct 
%

% Kalle Ruttik
% 26.10.2023

% clear all

% Input structure 

% tmp_network_id_dec = 19001;
% tmp_transmitter_address_dec = 300001;
% tmp_network_id_de = Beacon_header.network_id;
% tmp_transmitter_address_dec = Beacon_header.transmitter_address;
function [msg_bin] = mac_Common_Header_Beacon_header_constr( network_id, transmitter_address)

Beacon_header.netwrok_id_len          = 24;
Beacon_header.transmitter_address_len  = 32;

% makes binary bit sequences 
network_id_bin = fliplr(de2bi( network_id, Beacon_header.netwrok_id_len));
transmitter_address_bin = fliplr(de2bi( transmitter_address, Beacon_header.transmitter_address_len));

% makes tx bit sequence 
msg_bin = [network_id_bin transmitter_address_bin];

% makes tx byte sequence
%tx_bit_seq_7x8 = permute(reshape(msg_bin,8,7),[2 1]);
%tx_bytes = uint8(bi2de(tx_bit_seq_7x8))

% Beacon_header.network_id              = tmp_network_id_dec;
% Beacon_header.netwrok_id_len          = 24;
% Beacon_header.transmitter_address      = tmp_transmitter_address_dec;
% Beacon_header.transmitter_address_len  = 32;
end