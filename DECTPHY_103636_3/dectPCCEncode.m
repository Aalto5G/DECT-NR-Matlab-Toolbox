%
% encodes PCC message 
%
% [ind_pcc,pcc] = dectPCC(phy_Control_Field,mu_beta)
%
% endodes the control channel with channel coding and scramblest it
%

% Kalle Ruttik
% 4.8.2023

% 98 QPSK symobls symbols 

%%
% select 40 or 80 bits 
function [pcc] = dectPCCEncode(phy_Control_Field,mu_beta)



%% construct the pcc message 

msgType = phy_Control_Field.Type;
switch msgType 
  case 1
    msg = [];
    msg = [msg phy_Control_Field.header_format];
    msg = [msg fliplr(de2bi(phy_Control_Field.Packet_Length_Type,1))];
    msg = [msg fliplr(de2bi(phy_Control_Field.phy_Packet_Length,4))];
    msg = [msg fliplr(de2bi(phy_Control_Field.short_Network_ID,8))];    
    msg = [msg fliplr(de2bi(phy_Control_Field.transmitter_Identity,16))];
    msg = [msg fliplr(de2bi(phy_Control_Field.transmit_Power,4))];
    msg = [msg fliplr(de2bi(phy_Control_Field.reserved,1))];
    msg = [msg fliplr(de2bi(phy_Control_Field.DF_MCS,3))];
  case 2
    msg = [];
    msg = [msg phy_Control_Field.header_format];
    msg = [msg fliplr(de2bi(phy_Control_Field.Packet_Length_Type,1))];     % 1 bit. length given in slots 
    msg = [msg fliplr(de2bi(phy_Control_Field.phy_Packet_Length,4))];      % 4 bits.
    msg = [msg fliplr(de2bi(phy_Control_Field.short_Network_ID,8))];       % NetworkID&0x000000FF;      % 8 bits defined in 4.2.3.1   
    msg = [msg fliplr(de2bi(phy_Control_Field.transmitter_Identity,16))];  % 16 bits. RD ID. def. in 4.2.3.3
    msg = [msg fliplr(de2bi(phy_Control_Field.transmit_Power,4))];         % 4 bits 
    msg = [msg fliplr(de2bi(phy_Control_Field.DF_MCS,4))];                 % 4 bits. PDC MCS.
    msg = [msg fliplr(de2bi(phy_Control_Field.Receiver_Identity,16))];     % 16 bits. RD ID. def. in 4.2.3.3
    msg = [msg fliplr(de2bi(phy_Control_Field.Number_of_Spatial_Streams,2))]; % 2 bits. RD ID. def. in 6.2.1-4

    if (phy_Control_Field.header_format(3)==0)

    msg = [msg fliplr(de2bi(phy_Control_Field.DF_Redundancy_Version,2))];  % 2 bits. Packet redundancy version. def. 636-3 in 6.1.5-4
    msg = [msg fliplr(de2bi(phy_Control_Field.New_Data_Indicator,1))];     % 1 bits. HARQ combination info
    msg = [msg fliplr(de2bi(phy_Control_Field.DF_HARQ_Process_Number,3))]; % 3 bits. HARQ process nr

    else if (phy_Control_Field.header_format(3)==1)

    msg = [msg fliplr(de2bi(phy_Control_Field.reserved,6))];  % 2 bits. Packet redundancy version. def. 636-3 in 6.1.5-4
    
    end

    msg = [msg fliplr(de2bi(phy_Control_Field.Feedback_format,4))];        % 4 bits. Feedback Info coding Table 6.2.2-1
    msg = [msg fliplr(de2bi(phy_Control_Field.Feedback_info,12))];         % 12 bits. Feedback Info coding Table 6.2.2-1 
    end
end
pcc_bits = msg;
%crc attachement
pcc_crc_mask = 0x0000;
% crc masking 0x5555 for closed loop 
% crc masking 0xAAAA for beamforming masking 
pcc_bits_crc = lteCRCEncode(pcc_bits,'16',pcc_crc_mask); %7.5.2.1

cbs1 = lteCodeBlockSegment(pcc_bits_crc);

pcc_coded_blk = lteTurboEncode(cbs1);
outlen = 2*98;
rv = 0;

rmatched = lteRateMatchTurbo(pcc_coded_blk,outlen,rv);
% size(rmatched)

% scrambling
g_init = 0x44454354;
[seq,g_init] = ltePRBS(g_init,outlen);
% [seq,cinit] = ltePRBS(cinit,n,mapping)

d_scrambled = mod(double(rmatched)+seq,2);
pcc = d_scrambled;

% symbol mapping 7.5.5
% 
% %% receiver part
% d_descrambled = mod(d_scrambled + seq,2);
% 
% rrecovered = lteRateRecoverTurbo(uint8(d_descrambled),32,rv);
% size(rrecovered{1})
% 
% sum(pcc_coded_blk{1}~= pcc_coded_blk{1})
% 
% decoder_out = lteTurboDecode(rrecovered);
% [pcc_bits_rx,err] = lteCRCDecode(pcc_bits_crc,'16',pcc_crc_mask); %7.5.2.1
% 
% sum(pcc_bits'~=pcc_bits_rx)
% %%
% 
% 
% % N_PCC_subc=98 subcarriers turbo coding N_bps = 2 QPSK modulation
% % rv = 0; %redundancy value
% % after channel encoding the bits e_E-1 where E = N_PCC_subc * N_bps
% 
% % scrmabiling 7.5.4
% % d(i) = (e(i) + g(i))mod2
% % ginit = 0x44454354
% 
% % mapping to 0 spatial stream
% 
% 
% %% from help file
% trBlkLen = 135; 
% codewordLen = 450; 
% rv = 0;
% crcPoly = '24A';
% 
% trblockwithcrc = lteCRCEncode(zeros(trBlkLen,1),crcPoly);
% codeblocks = lteCodeBlockSegment(trblockwithcrc);
% turbocodedblocks = lteTurboEncode(codeblocks);
% codeword = lteRateMatchTurbo(turbocodedblocks,codewordLen,rv);
% rateRecovered = lteRateRecoverTurbo(codeword,trBlkLen,rv)

end