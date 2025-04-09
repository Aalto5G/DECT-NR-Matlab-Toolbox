%
% decodes and scrambles PCC data bits
%

% Kalle Ruttik
% 11.8.2023

% addpath('/home/kru/Kru/Proj/DECT/Matlab/decttoolbox/DECTPHY_103636_3')

function [pdc_dec_data] = dectPCCDecode(pcc_soft_bits)
% scrambling
g_init = 0x44454354;
pcc_soft_len = 2*98;
[seq,g_init] = ltePRBSkru(g_init,pcc_soft_len);
% [seq,cinit] = ltePRBS(cinit,n,mapping)

rv = 0;

d_descrambled = pcc_soft_bits.*(2*seq-1);

% TODO test for 40 and 80 bit pcc messages
pcc_symb = 40-8;
rrecovered = lteRateRecoverTurbo((d_descrambled),pcc_symb,rv);
decoder_out = lteTurboDecode(rrecovered);
%crc attachemen

pcc_crc_mask = 0x0000;
% crc masking 0x5555 for closed loop
% crc masking 0xAAAA for beamforming masking
  [tmp_dec,err]= lteCRCDecode(decoder_out{1},'16',pcc_crc_mask); %7.5.2.1
  phy_Control_Field.Type = 1;

if err ~= 0
  phy_Control_Field.Type = 2;
  pcc_symb = (80-8);
  rrecovered = lteRateRecoverTurbo((d_descrambled),pcc_symb,rv);
  decoder_out = lteTurboDecode(rrecovered);
  [tmp_dec,err]= lteCRCDecode(decoder_out{1},'16',pcc_crc_mask); %7.5.2.1
end

% map to the structure
%phy_Control_Field.Type = 1;
msgType = phy_Control_Field.Type; %phy_Control_Field.Type;
switch msgType
  case 1
    phy_Control_Field.header_format = double(tmp_dec(1:3))';
    phy_Control_Field.Packet_Length_Type = double(tmp_dec(4));
    phy_Control_Field.phy_Packet_Length = bi2de(fliplr(double(tmp_dec(5:8))'));
    phy_Control_Field.short_Network_ID = bi2de(fliplr(double(tmp_dec(9:16))'));
    phy_Control_Field.transmitter_Identity = bi2de(fliplr(double(tmp_dec(17:32))'));
    phy_Control_Field.transmit_Power = bi2de(fliplr(double(tmp_dec(33:36))'));
    phy_Control_Field.reserved = double(tmp_dec(37));
    phy_Control_Field.DF_MCS = bi2de(fliplr(double(tmp_dec(38:40))'));
  case 2
    phy_Control_Field.Type = 2;
    phy_Control_Field.header_format = double(tmp_dec(1:3))';    %
    phy_Control_Field.Packet_Length_Type = double(tmp_dec(4));                         % 1 bit. length given in slots
    phy_Control_Field.phy_Packet_Length =bi2de(fliplr(double(tmp_dec(5:8))'));         % 4 bits.
    phy_Control_Field.short_Network_ID =  bi2de(fliplr(double(tmp_dec(9:16))'));       % NetworkID&0x000000FF;      % 8 bits defined in 4.2.3.1
    phy_Control_Field.transmitter_Identity =  bi2de(fliplr(double(tmp_dec(17:32))'));  % 16 bits. RD ID. def. in 4.2.3.3
    phy_Control_Field.transmit_Power =  bi2de(fliplr(double(tmp_dec(33:36))'));        % 4 bits
    phy_Control_Field.DF_MCS = bi2de(fliplr(double(tmp_dec(38:40))'));                 % 4 bits. PDC MCS.
    phy_Control_Field.Receiver_Identity = bi2de(fliplr(double(tmp_dec(41:56))'));      % 16 bits. RD ID. def. in 4.2.3.3
    phy_Control_Field.Number_of_Spatial_Streams = bi2de(fliplr(double(tmp_dec(57:58))')); % 2 bits. RD ID. def. in 6.2.1-4

    if (phy_Control_Field.header_format(3)==0)

        phy_Control_Field.DF_Redundancy_Version = bi2de(fliplr(double(tmp_dec(59:60))'));  % 2 bits. Packet redundancy version. def. 636-3 in 6.1.5-4
        phy_Control_Field.New_Data_Indicator = bi2de(fliplr(double(tmp_dec(61))'));        % 1 bits. HARQ combination info
        phy_Control_Field.DF_HARQ_Process_Number =  bi2de(fliplr(double(tmp_dec(62:64))'));% 3 bits. HARQ process nr

    else if (phy_Control_Field.header_format(3)==1)
        phy_Control_Field.reserved = bi2de(fliplr(double(tmp_dec(59:64))'));  % 2 bits. Packet redundancy version. def. 636-3 in 6.1.5-4
    end
    phy_Control_Field.Feedback_format = bi2de(fliplr(double(tmp_dec(65:68))'));  % 2 bits. feedback version def. 636-3 in 6.1.5-4
    phy_Control_Field.Feedback_info = bi2de(fliplr(double(tmp_dec(69:80))'));  % 2 bits. feedback info. def. 636-3 in 6.1.5-4

%    phy_Control_Field = [];
    end
end
pdc_dec_data = phy_Control_Field;
end
