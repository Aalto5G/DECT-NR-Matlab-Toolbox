%
% RD Broadcasting Header construction
%

% Jaakko Niemistö
% 25.03.2024

function[msg_bin] = mac_Common_Header_RD_Broadcasting_Header_constr( reset, sequence_number, transmitter_address);

unicast_header.reset_len                = 1;
unicast_header.sequence_number_len      = 12;
unicast_header.transmitter_address_len  = 32;

%% generate binary
reserved_bin = de2bi(0,3);
reset_bin = fliplr(de2bi(double(reset),unicast_header.reset_len));
sequence_number_bin =  fliplr(de2bi(double(sequence_number),unicast_header.sequence_number_len));
transmitter_address_bin =  fliplr(de2bi(double(transmitter_address),unicast_header.transmitter_address_len));

msg_bin = [reserved_bin reset_bin sequence_number_bin transmitter_address_bin];

end