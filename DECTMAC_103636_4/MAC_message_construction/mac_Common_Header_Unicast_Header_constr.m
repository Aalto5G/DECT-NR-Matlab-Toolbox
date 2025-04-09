%
% Unicast Header construction t 
%

% Kalle Ruttik
% 25.10.2023

function[msg_bin] = mac_Common_Header_Unicast_Header_constr( reset, mac_sequence, sequence_number, receiver_address, transmitter_address);


% reset = 0;
% mac_sequence = 0;
% sequence_number = 0; 
% receiver_address = 0;
% transmitter_address = 0;

unicast_header.reset_len                = 1;
unicast_header.mac_sequence_len         = 4;
unicast_header.sequence_number_len      = 8;
unicast_header.receiver_address_len     = 32;
unicast_header.transmitter_address_len      = 32;

%% generate binary
reserved_bin = de2bi(0,3);
reset_bin = fliplr(de2bi(double(reset),unicast_header.reset_len));
mac_sequence_bin = fliplr(de2bi(double(mac_sequence),unicast_header.mac_sequence_len));
sequence_number_bin =  fliplr(de2bi(double(sequence_number),unicast_header.sequence_number_len));
receiver_address_bin =  fliplr(de2bi(double(receiver_address),unicast_header.receiver_address_len));
transmitter_address_bin =  fliplr(de2bi(double(transmitter_address),unicast_header.transmitter_address_len));

msg_bin = [reserved_bin reset_bin mac_sequence_bin sequence_number_bin receiver_address_bin transmitter_address_bin];

% 
% h11 = [0 0 1 1 1 0 0 0]
% h12 = [0 0 0 0 0 0 0 0];
% h13 = [0 0 0 0 0 0 0 0];
% h14 = [0 0 0 0 0 0 0 0];
% h15 = [0 0 0 0 0 0 0 0];
% h16 = [0 0 0 0 0 0 0 0];
% h17 = [0 0 0 0 0 0 0 0];
% h18 = [0 0 0 0 0 0 0 0];
% h19 = [0 0 0 0 0 0 0 0];
% h110 = [0 0 0 0 0 0 0 0];
% 
% h11_8 = uint8(bi2de(h11));
% h12_8 = uint8(bi2de(h12));
% h13_8 = uint8(bi2de(h13));
% h14_8 = uint8(bi2de(h14));
% h15_8 = uint8(bi2de(h15));
% h16_8 = uint8(bi2de(h16));
% h17_8 = uint8(bi2de(h17));
% h18_8 = uint8(bi2de(h18));
% h19_8 = uint8(bi2de(h19));
% h110_8 = uint8(bi2de(h110));
% 
% h1 = [h11_8 h12_8 h13_8 h14_8 h15_8 h16_8 h17_8 h18_8 h19_8 h110_8];
% 
% byte_in = de2bi(double(h1),8);
% 
% reserved = byte_in(1,1:3);
% reset    = byte_in(1,4);
% 
% tmp_mac_sequence_bin      = [byte_in(1,5:8)]
% tmp_sequence_number_bin   = [byte_in(2,:)];
% tmp_receiver_address_bin  = [byte_in(3,:) byte_in(4,:) byte_in(5,:) byte_in(6,:)];
% tmp_transmitter_address_bin = [byte_in(7,:) byte_in(8,:) byte_in(9,:) byte_in(10,:)];
% 
% tmp_mac_sequence_dec      = bi2de(fliplr(tmp_mac_sequence_bin));
% tmp_sequence_nubmer_dec   = bi2de(fliplr(tmp_sequence_number_bin));
% tmp_receiver_address_dec  = bi2de(fliplr(tmp_receiver_address_bin));
% tmp_transmitter_address_dec = bi2de(fliplr(tmp_transmitter_address_bin));
% 
% Unicast_header.reserver                 = reserved;
% Unicast_header.reserver_len             = 3;
% Unicast_header.reset                    = reserved;
% Unicast_header.reset_len                = 1;
% Unicast_header.mac_sequence             = tmp_mac_sequence_dec;
% Unicast_header.mac_sequence_len         = 4;
% Unicast_header.sequence_nubmer          = tmp_sequence_nubmer;
% Unicast_header.sequence_nubmer_len      = 8;
% Unicast_header.receiver_address         = tmp_receiver_address_dec;
% Unicast_header.receiver_address_len     = 32;
% Unicast_header.transmitter_address          = tmp_sequence_nubmer;
% Unicast_header.sequence_nubmer_len      = 8;
% 

end