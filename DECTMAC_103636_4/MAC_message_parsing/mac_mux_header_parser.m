%
% parses mac mux header for the ie types 
%

% Kalle Ruttik
% 26.10.2023


h11 = [0 0 1 1 1 0 0 0]
h12 = [0 0 1 1 1 0 0 0]
h13 = [0 0 1 1 1 0 0 0]
h11_8 = uint8(bi2de(h11));
h12_8 = uint8(bi2de(h12));
h13_8 = uint8(bi2de(h13));
h1 = [h11_8];
byte_in=de2bi(double(h1),8)

byte_in_len = de2bi(double(h12_8),8);
byte_in_len = de2bi(double([h12_8,h13_8]),8)

% mac_mux_header = mac_multiplexing_header(byte_in(1,:));

switch mac_mux_header.mac_ext
  case 0:
    % 0 0: No length field is included in the IE header. The IE type defines the length of the IE payload.
    sdu_len = 0;
    break;
  case 1:
    % 0 1: 8 bit length included indicating the length of the IE payload.
    sdu_len = bi2de(fliplr(byte_in(2,:));
    break;
  case 2:
    % 1 0: 16 bit length included indicating the length of the IE payload.
    sdu_len = bi2de(fliplr([byte_in(2,:) byte_in(3,:)]);
    break;
  case 3:
    % 1 1: Short IE, a one bit length field is included in the IE header. The IE payload size is 0 bytes when the length bit
    % (bit 2) is set to 0, or 1 byte when the length bit (bit 2) is set to 1, shown in Figure 6.3.4-1 option a) and option b).
    break;
end

