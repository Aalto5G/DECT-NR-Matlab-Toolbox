%
% creates a DATA MAC PDU header from input struct 
%
% Input structure 
% Reset           - reset bit for the first packet  
% sequence_number - sequence numer max 12 bit long
%
% msg_bin - binary oputput sequence 

% Kalle Ruttik
% 23.11.2023

% clear all

function [msg_bin] = mac_Common_Header_DATA_MAC_PDU_Header_constr( Reset, sequence_number)

% makes binary bit sequences 
DATA_MAC_PDU_header.Reset_len = 1;
DATA_MAC_PDU_header.sequence_number_len = 12;
reserved_bin = de2bi( 0, 3);
Reset_bin = Reset;
sequence_number_bin = fliplr(de2bi( sequence_number, DATA_MAC_PDU_header.sequence_number_len));

% makes tx bit sequence 
msg_bin = [reserved_bin Reset_bin sequence_number_bin];

end