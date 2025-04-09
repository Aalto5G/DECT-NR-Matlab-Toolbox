%
% DECT phy simulation
% 

% Kalle Ruttik
% 3.8.2023

clear all
close all 

addpath("./DECTPHY_103636_3")
addpath("./DECTPHY_103636_3/codec")
addpath("./DECTMAC_103636_4")

%% config
NetworkID = 0x0A;
tmpID = dec2bin(NetworkID,32);
NetworkID_short = bin2dec(tmpID(25:end));
NetworkID_msb24 = bin2dec(tmpID(1:24));
% 103 636-3 Table 7.2.1 
% Transmission modes and transmission mode signalling

transmission_modes.N_ss_capability = 1;
% default values for the config 
transmission_modes.tx_mode_signaling = 'single_antenna'; % transmission mode signalling
transmission_modes.N_eff_tx = 1;
transmission_modes.N_ss = 1;
transmission_modes.pdc_closed_loop = 'false';
transmission_modes.pdc_beam_forming = 'false';
transmission_modes.pdc_effective_transmission_mode = 'single_antenna';
transmission_modes.N_TS = 1;
transmission_modes.N_TX = 1;
transmission_modes.pcc_effective_transmission_mode = 'single_antenna';
transmission_modes.pcc_beam_forming = 'false';

%% MAC parameters for pcc Type 1
% 103 636-4 Tabel 6.2.1 
phy_Control_Field1.Type = 1;
phy_Control_Field1.header_format = [0 0 0];     %
phy_Control_Field1.Packet_Length_Type = 1;      % 1 bit. length given in slots 
phy_Control_Field1.phy_Packet_Length = 1;       % 4 bits.
phy_Control_Field1.short_Network_ID = NetworkID_short; %NetworkID&0x000000FF;      % 8 bits defined in 4.2.3.1
phy_Control_Field1.transmitter_Identity =  256; % 16 bits. RD ID. def. in 4.2.3.3
phy_Control_Field1.transmit_Power = 1;          % 4 bits 
phy_Control_Field1.reserved = 0;                % 1 bit 
phy_Control_Field1.DF_MCS = 1;                  % 3 bits. PDC MCS. 

%% MAC parameters for pcc Type 2 header 000
% 103 636-4 Tabel 6.2.1 
phy_Control_Field2.Type = 2;
phy_Control_Field2.header_format = [0 0 0];     %
phy_Control_Field2.Packet_Length_Type = 1;      % 1 bit. length given in slots 
phy_Control_Field2.phy_Packet_Length = 5;       % 4 bits.
phy_Control_Field2.short_Network_ID = NetworkID_short; %NetworkID&0x000000FF;      % 8 bits defined in 4.2.3.1
phy_Control_Field2.transmitter_Identity =  256; % 16 bits. RD ID. def. in 4.2.3.3
phy_Control_Field2.transmit_Power = 1;          % 4 bits 
phy_Control_Field2.DF_MCS = 1;                  % 4 bits. PDC MCS. 
phy_Control_Field2.Receiver_Identity =  256;    % 16 bits. RD ID. def. in 4.2.3.3
phy_Control_Field2.Number_of_Spatial_Streams = 1;    % 2 bits. RD ID. def. in 6.2.1-4
phy_Control_Field2.DF_Redundancy_Version = 0;    % 2 bits. Packet redundancy version. def. 636-3 in 6.1.5-4
phy_Control_Field2.New_Data_Indicator = 0;      % 1 bits. HARQ combination info
phy_Control_Field2.DF_HARQ_Process_Number = 0;  % 3 bits. HARQ process nr
phy_Control_Field2.Feedback_format = 0;         % 4 bits. Feedback Info coding Table 6.2.2-1
phy_Control_Field2.Feedback_info = 0;           % 12 bits. Feedback Info 6.2.22

%% MAC parameters for pcc Type 2 header 001
% 103 636-4 Tabel 6.2.1 
phy_Control_Field21.Type = 2;
phy_Control_Field21.header_format = [0 0 1];     %
phy_Control_Field21.Packet_Length_Type = 1;      % 1 bit. length given in slots 
phy_Control_Field21.phy_Packet_Length = 5;       % 4 bits.
phy_Control_Field21.short_Network_ID = NetworkID_short; %NetworkID&0x000000FF;      % 8 bits defined in 4.2.3.1
phy_Control_Field21.transmitter_Identity =  256; % 16 bits. RD ID. def. in 4.2.3.3
phy_Control_Field21.transmit_Power = 1;          % 4 bits 
phy_Control_Field21.DF_MCS = 1;                  % 4 bits. PDC MCS. 
phy_Control_Field21.Receiver_Identity =  256;    % 16 bits. RD ID. def. in 4.2.3.3
phy_Control_Field21.Number_of_Spatial_Streams = 1;    % 2 bits. RD ID. def. in 6.2.1-4
phy_Control_Field21.reserved = 0;                % 6 bits. Packet redundancy version. def. 636-3 in 6.1.5-4
phy_Control_Field21.Feedback_format = 1;         % 4 bits. Feedback Info coding Table 6.2.2-1
phy_Control_Field21.Feedback_info = 279;           % 12 bits. Feedback Info 6.2.22

phy_Control_Field = phy_Control_Field21;

%% scaling config 
bw_scaling.mu_inx = 1;
bw_scaling.beta_inx =1;

% fetch frame parameters from the table 103636-3 1.4.1 Table 4.3-1
[mu_beta] = dectPhyFrameParameters_Table431(bw_scaling.mu_inx,bw_scaling.beta_inx);



%% PHY frame generation
% STF 

stf     = dectSyncTrainingField(mu_beta); %(phy_Control_Field,mu_beta);  % return sync sequence in time 

[pilots,ind_pilots,ind_pilots_DFT,grid_withPilots] = dectPilots(phy_Control_Field, transmission_modes, mu_beta);

%[pilots,ind_pilots,grid_withPilots,locPilotsInSym, locPilotSym, yDRS]  = dectPilots(phy_Control_Field,transmission_modes,mu_beta);


[pcc_enc_data]       = dectPCCEncode(phy_Control_Field,mu_beta);
[ind_pcc]   = dectPCCind(transmission_modes,mu_beta);

[ind_pdc]   = dectPDCind(phy_Control_Field,transmission_modes,mu_beta);

N_PDC_re = length(ind_pdc);
[N_TB_bits] = dectTransportBlockSize(N_PDC_re,phy_Control_Field,transmission_modes,mu_beta);

data = randn(1,N_TB_bits)>0;
% estimate the input data packet size 
[pdc_enc_data] = dectPDCEncode( data, NetworkID, N_PDC_re, phy_Control_Field,transmission_modes,mu_beta);

% modulation 
[pcc_symbols] = dectSymbolMapping(pcc_enc_data,1);
[pdc_symbols] = dectSymbolMapping(pdc_enc_data,phy_Control_Field.DF_MCS);
% mapping to RE
%%
dect_grid = grid_withPilots;
dect_grid(ind_pcc) = pcc_symbols;
dect_grid(ind_pdc) = pdc_symbols;

%% transmit stream mapping: not implemented for 1x1

%% MIMO mapping: not implemented for 1x1

%%
plotGrid = dect_grid*10;
plotGrid(ind_pcc) = pcc_symbols*50;
plotGrid(ind_pdc) = pdc_symbols*100;
pcolor(abs(plotGrid))
%%
% ifft + cp
[waveform,info] = dectOFDMModulate(dect_grid,transmission_modes,mu_beta);


% frame construction
tx_frame = [permute(stf,[2 1]); waveform];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Receiver 
%
% sync remove sync sequnce
[r,mu_beta_rx] = dectSync(tx_frame);


% first two symbols for pcc
rx_frame = r([1:(2*72)]);
[dect_grid_rx,info] = dectOFDMDemodulate(rx_frame,mu_beta);

[ind_pcc]   = dectPCCind(transmission_modes,mu_beta);

%% estimates pcc
% eq
phy_Control_Field.Packet_Length_Type = 0;      % 1 bit. length given in slots 
phy_Control_Field.phy_Packet_Length = 0;       % 4 bits.
[pilots,ind_pilots,ind_pilots_DFT,grid_withPilots] = dectPilots(phy_Control_Field, transmission_modes, mu_beta);


%[h_est] = dectChannelEstimate(dect_grid_rx,phy_Control_Field,transmission_modes,mu_beta);
[h_est] = dectPCCSymbolsChannelEstimate(dect_grid_rx,transmission_modes,mu_beta);
[dect_grid_rx_eq_pcc] = dectPCCSymbolsZeroForcing(dect_grid_rx,h_est,transmission_modes,mu_beta);
%[dect_grid_rx_eq] = dectZeroForcing(dect_grid_rx,h_est,phy_Control_Field,transmission_modes,mu_beta);


%%
% pcc extraction
pcc_re_symbols = dect_grid_rx_eq_pcc(ind_pcc);
pcc_soft_symbols = dectSymbolDeMapping(pcc_re_symbols,1);
[pcc_struct] = dectPCCDecode(pcc_soft_symbols)



% % % symbol extraction fft
% % [dect_grid_rx,info] = dectOFDMDemodulate(rx_frame,mu_beta);
% % 
% % % eq
% % 
% % [h_est] = dectChannelEstimate(dect_grid_rx,phy_Control_Field,transmission_modes,mu_beta);
% % [dect_grid_rx_eq] = dectZeroForcing(dect_grid_rx,h_est,phy_Control_Field,transmission_modes,mu_beta);
% % 
% % % pcc extraction
% % pcc_re_symbols = dect_grid_rx_eq(ind_pcc);
% % pcc_soft_symbols = dectSymbolDeMapping(pcc_re_symbols,1);
% % [pcc_struct] = dectPCCDecode(pcc_soft_symbols);


% %% pdc extraction
% N_DFT = mu_beta.N_DFT;
% N_beta_occ = mu_beta.N_beta_occ; %56 % number of occupied carriers 
% k_beta_occ = [-N_beta_occ/2:-1 1:N_beta_occ/2];
% half_shift = N_DFT/2+1;
% tmp_addr= k_beta_occ+half_shift;
% for i1 = 1 : size(dect_grid_rx,2)
%  dect_grid_rx_sym(:,i1) = dect_grid_rx(tmp_addr,i1);
% end
% pcc_re_symbols_noeq = dect_grid_rx_sym(ind_pcc);
% ch_est2 = pcc_re_symbols_noeq./permute(pcc_symbols_remapped,[2 1]);

%%
% h1 = permute(pcc_symbols_remapped,[2 1]); 
% h2 = pcc_re_symbols;
% h3 = h2./h1;
% 
% c1 = zeros(size(dect_grid_rx_sym));
% c1(ind_pilots) = pilots;
% c1(ind_pcc) = pcc_symbols_remapped;
% c2 = dect_grid_rx_sym./c1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% decodes the data 

if pcc_struct.Packet_Length_Type == 0
  N_PACKET_symb = (pcc_struct.phy_Packet_Length+1)*mu_beta.N_SLOTmu_symb/mu_beta.N_SLOTmu_subslot;
else 
 if pcc_struct.Packet_Length_Type == 1
   N_PACKET_symb = (pcc_struct.phy_Packet_Length+1)*mu_beta.N_SLOTmu_symb;
 end
end
len = (N_PACKET_symb-2)*72;
%rx_frame = r(startLoc(1)+ [1:len]);
% rx_frame = r(loc1 + [1:(40*72)]);
rx_frame = r([1:len]);


%% symbol extraction
[dect_grid_rx,info] = dectOFDMDemodulate(rx_frame,mu_beta);

[h_est] = dectChannelEstimate(dect_grid_rx,pcc_struct,transmission_modes,mu_beta);

[dect_grid_rx_eq] = dectZeroForcing(dect_grid_rx,h_est,pcc_struct,transmission_modes,mu_beta);

% data demapping 
[ind_pdc]   = dectPDCind(pcc_struct,transmission_modes,mu_beta);

N_PDC_re = length(ind_pdc);

pdc_re_symbols = dect_grid_rx_eq(ind_pdc);
MCS = pcc_struct.DF_MCS;
pdc_soft_symbols = dectSymbolDeMapping(pdc_re_symbols,MCS);


G = length(pdc_soft_symbols); %N_PDC_re;
%% descrambling
if pcc_struct.Type == 1
 g_init = 0x00000001;
 %g_init = 0x00000101;
 tmp = de2bi(NetworkID,32);
 g_init = bi2de(tmp(1:8));
else 
  tmp = de2bi(NetworkID,32);
  g_init = bi2de(tmp(9:end));
end

%[seq,g_init] = ltePRBS(g_init,G);
[seq,g_init] = ltePRBSkru(g_init,G);

d_descrambled2 = pdc_soft_symbols.*(2*seq(1:length(pdc_soft_symbols))-1);

N_SS = 1;
N_bps = 2;
R = 1/2;
[N_TB_bits] = bitLenEval(N_PDC_re, N_SS, N_bps, R);


% trbBlkLen = 32;
rv = 0;
%pdc_coded_blk_rx = lteRateRecoverTurbo(d_descrambled2,N_TB_bits,rv);
pdc_coded_blk_rx = dect_RateRecoverTurbo(d_descrambled2,N_TB_bits,rv,N_SS,N_bps);


%dataRx_crc = lteTurboDecode(pdc_coded_blk_rx); % dk
datarx_crc_seg = LTE_TurboDecode(pdc_coded_blk_rx); % dk

[datarx_crc,err] =LTE_CodeBlockDesegment(datarx_crc_seg,N_TB_bits+24);
err
crcPoly = '24A';
[pdc_dec_data_rx,err] = lteCRCDecode(datarx_crc,crcPoly);
err
if err == 0
  hout = reshape(pdc_dec_data_rx,8,[]);
  bi2de(fliplr(hout'))';
end

sum(data~=pdc_dec_data_rx')

[pdc_MACSDU] = dectPDCDecode(pdc_soft_symbols, NetworkID, N_PDC_re, pcc_struct,transmission_modes,mu_beta);

%t test if decoding is correct
sum(data~=pdc_MACSDU')

% [data_decoded] = dectPDCDecode((1-2*pdc_enc_data),NetworkID,N_PDC_re, phy_Control_Field,transmission_modes,mu_beta);
% sum(data~=data_decoded')
