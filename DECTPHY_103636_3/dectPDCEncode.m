%
% encodes and scrambles PDC data bits 
%
% Bit collection section and transmission
% 103636-3 
% 6.1.5.3
%

% Kalle Ruttik
% 10.8.2023

function [pdc_enc_data] = dectPDCEncode(pdc_input_bits, NetworkID,N_PDC_re, phy_Control_Field,transmission_modes,mu_beta)

N_eff_tx = transmission_modes.N_eff_tx;    % number of effective antennas 
N_DFT = mu_beta.N_DFT;
N_TS = transmission_modes.N_TS;        % number of transmit streams 
N_beta_occ = mu_beta.N_beta_occ; %56 % number of occupied carriers 
% NetworkID = phy_Control_Field.short_Network_ID;
% N_PDC_re = length(ind_pdc);
N_ss = transmission_modes.N_ss;

PhysicalLayerControlFieldType = phy_Control_Field.Type;
MCS = phy_Control_Field.DF_MCS;



[modulation,N_bps,R] = dectMCSTable(MCS);

N_PDC_subc = N_PDC_re;
G = N_ss*N_PDC_subc*N_bps;

%crc attachement
crcPoly = '24A';
pdc_input_bits_crc = lteCRCEncode(pdc_input_bits,crcPoly); %7.6.2

% cbs = lteCodeBlockSegment(pdc_input_bits_crc);
[cbs,cStruct] = dect_CodeBlockSegment(pdc_input_bits_crc);

pdc_coded_blk = lteTurboEncode(cbs);
%pdc_coded_blk = LTE_TurboEncode(cbs);

%%
rv = 0;

N_ss=transmission_modes.N_ss;
[rmatched,w] = LTE_RateMatchTurbo(pdc_coded_blk,G,rv,N_ss,N_bps);

% rmatched = lteRateMatchTurbo(pdc_coded_blk,G,rv); % 7.6.3 <- 6.1.3



% size(rmatched);

% % %% TEST
% % % with random bits 
% % % inpData = randn(trBlkLen,1)>0;
% % % trblockwithcrc = lteCRCEncode(inpData,crcPoly);
% % % codeblocks = lteCodeBlockSegment(trblockwithcrc);
% % % turbocodedblocks = lteTurboEncode(codeblocks)
% % % codeword = lteRateMatchTurbo(turbocodedblocks,codewordLen,rv);
% % modcodeword = rmatched*2-1;
% % [ind_pdc]   = dectPDCind(phy_Control_Field,transmission_modes,mu_beta);
% % N_PDC_re = length(ind_pdc);
% % [N_TB_bits] = dectTransportBlockSize(N_PDC_re,phy_Control_Field,transmission_modes,mu_beta);
% % rateRecovered = lteRateRecoverTurbo(modcodeword,N_TB_bits,rv);
% % decodedblocks = lteTurboDecode(rateRecovered);
% % % sum((rateRecovered{1}>0)~= turbocodedblocks{1})
% % % l1 = find(rateRecovered{1}~= turbocodedblocks{1})
% % % h1 = rateRecovered{1};
% % % h2 = turbocodedblocks{1};
% % % [h1(l1)'; h2(l1)']
% % outDataCRC = lteCodeBlockDesegment(decodedblocks,N_TB_bits+24);
% % decoder_out = lteCRCDecode(outDataCRC,crcPoly);
% % sum(pdc_input_bits~=decoder_out')

%%
% scrambling
tmpID = dec2bin(NetworkID,32);
if PhysicalLayerControlFieldType == 0
g_init = 0x00000000;
else 
  if PhysicalLayerControlFieldType == 1
      rv = 0;
      % tmpID_24 = bin2dec(tmpID(9:end));
      % g_init = tmpID_24; %mod(bitshift(NetworkID,8),0x00ffffff);

      tmp = de2bi(NetworkID,32);
      g_init = bi2de(tmp(1:8));
      tmpID_short = g_init;
  else 
    if PhysicalLayerControlFieldType == 2
      % rv = 
      %tmpID_short = bin2dec(tmpID(25:end));
      %g_init = tmpID_short; % mod(NetworkID,0x000000ff);
      tmp = de2bi(NetworkID,32);
      g_init = bi2de(tmp(9:end));
    end
  end
end
[seq,g_init] = ltePRBS(g_init,G);
% [seq,cinit] = ltePRBS(cinit,n,mapping)

d_scrambled = mod(double(rmatched)+seq,2);
pdc_enc_data = d_scrambled;


% % %  % d2= mod(pdc_enc_data+seq,2);
% % d_descrambled = (1-2*pdc_enc_data).*(2*seq-1);
% % % %h1 = 0;
% % 
% % 
% % % d_descrambled = (pdc_soft_bits).*(1-2*seq);
% % [N_TB_bits] = dectTransportBlockSize(N_PDC_re,phy_Control_Field,transmission_modes,mu_beta);
% % 
% % rrecovered = lteRateRecoverTurbo((d_descrambled),N_TB_bits,rv);
% % % % size(rrecovered{1})
% % % 
% % % % sum(rrecovered{1}~= pdc_coded_blk{1})
% % decoder_out = lteTurboDecode(rrecovered);
% % % h1 = 0;
% % sum([pdc_input_bits_crc'~=decoder_out{1}'])
% % [pdc_input_bits_crc(1:10)'; decoder_out{1}(1:10)']

% 98 QPSK symobls symbols 

% % %%
% % % select 40 or 80 bits 
% % lenBits = 7000;
% % N_ss = 1;           % streams
% % N_PDC_subc = 10000; % subcarriers
% % N_bps = 2;          % bits per modulation QPSK   
% % NetworkID = 0x00123456;
% % PhysicalLayerControlFieldType = 0; % 0 no control field, 1 type 1, 2 type 2 - impacts scrambling seq
% % 
% % pdc_bits = randn(1,lenBits)>0;
% % 
% % G = N_ss*N_PDC_subc*N_bps;
% % outlen = G; % how many bits are in output
% % 
% % %%
% % %crc attachement
% % pdc_bits_crc = lteCRCEncode(pdc_bits,'24A'); %7.6.2
% % 
% % % segmentation has to be modified for the long block sequence 
% % % for now it is only for the long sequence
% % cbs1 = lteCodeBlockSegment(pdc_bits_crc);
% % 
% % pdc_coded_blk = lteTurboEncode(cbs1);
% % 
% % %%
% % rv = 0;
% % rmatched = lteRateMatchTurbo(pdc_coded_blk,outlen,rv); % 7.6.3 <- 6.1.3
% % % size(rmatched);
% % 
% % %%
% % % scrambling
% % 
% % if PhysicalLayerControlFieldType == 0
% % g_init = 0x00000000;
% % else 
% %   if PhysicalLayerControlFieldType == 1
% %     g_init = mod(bitshift(NetworkID,8),0x00ffffff);
% %   else 
% %     if PhysicalLayerControlFieldType == 2
% %       g_init = mod(NetworkID,0x000000ff);
% %     end
% %   end
% % end
% % [seq,g_init] = ltePRBS(g_init,outlen);
% % % [seq,cinit] = ltePRBS(cinit,n,mapping)
% % 
% % d_scrambled = mod(double(rmatched)+seq,2);
% % 
% % pdc_data = d_scrambled;
% % % symbol mapping 7.6.5

% %% receiver part
% d_descrambled = mod(d_scrambled + seq,2);
% 
% rrecovered = lteRateRecoverTurbo(uint8(d_descrambled),lenBits,rv);
% size(rrecovered{1})
% 
% sum(rrecovered{1}~= pdc_coded_blk{1})
% decoder_out = lteTurboDecode(rrecovered);
% [pdc_bits_rx,err] = lteCRCDecode(pdc_bits_crc,'24A'); %7.5.2.1
% 
% sum(pdc_bits'~=pdc_bits_rx)

end