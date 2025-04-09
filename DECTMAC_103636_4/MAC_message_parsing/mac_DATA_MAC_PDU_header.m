%
% Parses the MAC PDU header from hex numbers into struct 
%

% Kalle Ruttik
% 25.10.2023

h11 = [0 0 1 1 1 0 0 0]
h12 = [0 0 0 0 0 0 0 0];

h11_8 = uint8(bi2de(h11));
h12_8 = uint8(bi2de(h12));

h1 = [h11_8 h12_8]

de2bi(double(h1),8)
byte_in(1,:) = de2bi(double(h11_8),8);
byte_in(2,:) = de2bi(double(h12_8),8);

% h1 = uint8(bi2de(fliplr(tmpData)))

reset = byte_in(1,4);
tmp_sequence_number_bin = [byte_in(1,5:8) byte_in(2,1:8)];
tmp_sequence_number_de = bi2de(fliplr(tmp_sequence_number_bin));

DATA_MAC_PDU_header.reserved             = 0;
DATA_MAC_PDU_header.reserved_len         = 3;
DATA_MAC_PDU_header.reset                = 1;
DATA_MAC_PDU_header.reset_len            = 1; 
DATA_MAC_PDU_header.sequence_number      = tmp_sequence_number_de;
DATA_MAC_PDU_header.sequence_number_len  = 12;

