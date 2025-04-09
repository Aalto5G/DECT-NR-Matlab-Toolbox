%
% Parses the RD Broadcast header from hex numbers into struct 
%

% Kalle Ruttik
% 26.10.2023

h11 = [0 0 1 1 1 0 0 0];
h12 = [0 0 0 0 0 0 0 0];
h13 = [0 0 0 0 0 0 0 0];
h14 = [0 0 0 0 0 0 0 0];
h15 = [0 0 0 0 0 0 0 0];
h16 = [0 0 0 0 0 0 0 0];

h11_8 = uint8(bi2de(h11));
h12_8 = uint8(bi2de(h12));
h13_8 = uint8(bi2de(h13));
h14_8 = uint8(bi2de(h14));
h15_8 = uint8(bi2de(h15));
h16_8 = uint8(bi2de(h16));

h1 = [h11_8 h12_8 h13_8 h14_8 h15_8 h16_8];

byte_in = de2bi(double(h1),8);

reserved = byte_in(1,1:3);
reset    = byte_in(1,4);

tmp_sequence_number_bin   = [byte_in(1,5:8) byte_in(2,:)];
tmp_sequence_number_dec   = bi2de(fliplr(tmp_sequence_number_bin));
tmp_transmitter_address_bin = [byte_in(3,:) byte_in(4,:) byte_in(5,:) byte_in(6,:)];
tmp_transmitter_address_dec = bi2de(fliplr(tmp_transmitter_address_bin));

Unicast_header.reserver                 = reserved;
Unicast_header.reserver_len             = 3;
Unicast_header.reset                    = reset;
Unicast_header.reset_len                = 1;
Unicast_header.sequence_nubmer          = tmp_sequence_number_dec;
Unicast_header.sequence_nubmer_len      = 12;
Unicast_header.transmitter_address      = tmp_transmitter_address_dec;
Unicast_header.transmitter_address_len  = 32;

