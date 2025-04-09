%
% Associate request message tx rx
%
% 103634-4 
% 6.4.2.4
% send in Random access resources and with Unicast Header 6.3.3.2
% It followns RD capability IE and after that some optional IEs may follow

% Kalle Ruttik 
% 30.10.2023

clear all 

% addpath(genpath([fileparts(fileparts(pwd)), filesep, 'YourCode.m' ]));

%% config
NetworkID = 0x11111111;
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
phy_Control_Field2.phy_Packet_Length = 1;       % 4 bits.
phy_Control_Field2.short_Network_ID = NetworkID_short; %NetworkID&0x000000FF;      % 8 bits defined in 4.2.3.1
phy_Control_Field2.transmitter_Identity =  256; % 16 bits. RD ID. def. in 4.2.3.3
phy_Control_Field2.transmit_Power = 1;          % 4 bits 
phy_Control_Field2.DF_MCS = 1;                  % 4 bits. PDC MCS. 
phy_Control_Field2.Receiver_Identity =  256;    % 16 bits. RD ID. def. in 4.2.3.3
phy_Control_Field2.Number_of_Spatial_Streams = 1;    % 2 bits. RD ID. def. in 6.2.1-4
phy_Control_Field2.DF_Redundancy_Version = 0;    % 2 bits. Packet redundancy version. def. 636-3 in 6.1.5-4
phy_Control_Field2.New_Data_Indicator = 0;      % 1 bits. HARQ combination info
phy_Control_Field2.DF_HARQ_Process_Number = 0;  % 3 bits. HARQ process nr
phy_Control_Field2.Feedback_Format = 0;         % 4 bits. Feedback Info coding Table 6.2.2-1
phy_Control_Field2.Feedback_Info = 0;           % 12 bits. Feedback Info 6.2.22

%% MAC parameters for pcc Type 2 header 001
% 103 636-4 Tabel 6.2.1 
phy_Control_Field21.Type = 2;
phy_Control_Field21.header_format = [0 0 1];     %
phy_Control_Field21.Packet_Length_Type = 0;      % 1 bit. length given in slots 
phy_Control_Field21.phy_Packet_Length = 1;       % 4 bits.
phy_Control_Field21.short_Network_ID = NetworkID_short; %NetworkID&0x000000FF;      % 8 bits defined in 4.2.3.1
phy_Control_Field21.transmitter_Identity =  256; % 16 bits. RD ID. def. in 4.2.3.3
phy_Control_Field21.transmit_Power = 1;          % 4 bits 
phy_Control_Field21.DF_MCS = 1;                  % 4 bits. PDC MCS. 
phy_Control_Field21.Receiver_Identity =  256;    % 16 bits. RD ID. def. in 4.2.3.3
phy_Control_Field21.Number_of_Spatial_Streams = 1;    % 2 bits. RD ID. def. in 6.2.1-4
phy_Control_Field21.reserved = 0;                % 6 bits. Packet redundancy version. def. 636-3 in 6.1.5-4
phy_Control_Field21.Feedback_Format = 0;         % 4 bits. Feedback Info coding Table 6.2.2-1
phy_Control_Field21.Feedback_Info = 0;           % 12 bits. Feedback Info 6.2.22

phy_Control_Field = phy_Control_Field2;

%% scaling config 
% addpath('/home/kru/Kru/Proj/DECT/Matlab/decttoolbox/DECTPHY_103636_3')  
addpath('../../../decttoolbox/DECTPHY_103636_3')  

% set the mu and beta 
bw_scaling.mu_inx = 1;
bw_scaling.beta_inx =1;

% fetch frame parameters from the table 103636-3 1.4.1 Table 4.3-1
[mu_beta] = dectPhyFrameParameters_Table431(bw_scaling.mu_inx,bw_scaling.beta_inx);

% estimates the packet length
% for each subblock length
for i1 =1:15
phy_Control_Field.phy_Packet_Length = i1;
[ind_pdc]   = dectPDCind(phy_Control_Field,transmission_modes,mu_beta);
N_PDC_re = length(ind_pdc);
[N_TB_bits] = dectTransportBlockSize(N_PDC_re,phy_Control_Field,transmission_modes,mu_beta);
bits_per_symb(i1) = N_TB_bits;
end

%% Unicast header 
%addpath('/home/kru/Kru/Proj/DECT/Matlab/Devel/Messages/MAC_message_construction')  
addpath('../MAC_message_construction')  
addpath('../MAC_message_construction/MAC_messages')  

% mac_Unicast_Header_construction 

% mac header type: Unicast header
version = 0;
mac_security = 0;  % not used 
unicast_header = 2;
[mac_header_type] = mac_MAC_Header_Type_constr(version,mac_security,unicast_header);

% mac common header: Unicast header
reset = 0;
mac_sequence = 0;
sequence_number = 0;
receiver_address = 10;
transmitter_address = 11;
[mac_common_header] = mac_Common_Header_Unicast_Header_constr( reset, mac_sequence, sequence_number, receiver_address, transmitter_address);

% mac_Beacon_header_construction
tmp_network_id_dec = 19001;
tmp_transmitter_address_dec = 300001;

% associate_response_msg


ack_nack = 0;
HARQ_mod = 0;
Number_of_flows = 0;
Group = 0;
Tx_power = 1;
Reject_cause = 0;
Reject_time = 0;
HARQ_processes_RX = 0;
MAX_HARQ_Re_RX = 0;
HARQ_processes_TX = 0;
MAX_HARQ_Re_TX = 0;
Flow_ID = 0;
group_ID = 0;
Resource_tag = 0;

[association_response_msg_ie] = association_response_msg_ie_constr(ack_nack,HARQ_mod,Number_of_flows,Group,Tx_power,Reject_cause,Reject_time,HARQ_processes_RX,MAX_HARQ_Re_RX,HARQ_processes_TX,MAX_HARQ_Re_TX,Flow_ID,group_ID,Resource_tag);


% rd capacility ie
number_of_phy_capabilities = 0;
release = 0;
operating_modes = 2;
mesh = 0;
schedul = 0;
mac_security = 0;
dlc_service_type = 0;
rd_power_class = 0;
max_nss_for_rx = 1;
rx_for_tx_diversity = 0;
rx_gain = 1;
max_mcs = 0;
soft_buffer_size = 1;
num_of_HARQ_processes = 1;
HARQ_feedback_delay = 1;
radio_device_class_mu = 0;
radio_device_class_beta = 0;
rd_power_class2 = 0;
max_nss_for_rx2 = 0;
rx_for_tx_diversity2 = 0;
rx_gain2 = 1;
max_mcs2 = 0;
soft_buffer_size2 = 1;
num_of_HARQ_processes2 = 1;
HARQ_feedback_delay2 = 1;

[rd_capability_msg_ie] = rd_capability_ie_constr(number_of_phy_capabilities,release,operating_modes, mesh, schedul, mac_security, dlc_service_type,...
  rd_power_class, max_nss_for_rx, rx_for_tx_diversity, rx_gain, max_mcs, soft_buffer_size, num_of_HARQ_processes, HARQ_feedback_delay, radio_device_class_mu, radio_device_class_beta,...
  rd_power_class2, max_nss_for_rx2, rx_for_tx_diversity2,rx_gain2, max_mcs2, soft_buffer_size2, num_of_HARQ_processes2, HARQ_feedback_delay2 );


% combining mac message
mac_packet_info = [mac_header_type mac_common_header association_response_msg_ie rd_capability_msg_ie];

% find suitable packet size as number of frames
len_msg= length(mac_packet_info);

[N_symb,N_TB_bits] = mac_fit_data_into_min_symbols(len_msg, phy_Control_Field, transmission_modes, mu_beta);
phy_Control_Field.phy_Packet_Length = N_symb;

% padding 
[msg_packet] = mac_add_padding(mac_packet_info, phy_Control_Field,transmission_modes,mu_beta);


% encoding 
[ind_pdc]   = dectPDCind(phy_Control_Field,transmission_modes,mu_beta);
N_PDC_re = length(ind_pdc);
[pdc_enc_data] = dectPDCEncode( msg_packet, NetworkID, N_PDC_re, phy_Control_Field,transmission_modes,mu_beta);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Putting MAC msg packet into PHY packet

stf     = dectSyncTrainingField(mu_beta); %(phy_Control_Field,mu_beta);  % return sync sequence in time 

[pilots,ind_pilots,ind_pilots_DFT,grid_withPilots] = dectPilots(phy_Control_Field, transmission_modes, mu_beta);

%[pilots,ind_pilots,grid_withPilots,locPilotsInSym, locPilotSym, yDRS]  = dectPilots(phy_Control_Field,transmission_modes,mu_beta);

[pcc_enc_data]       = dectPCCEncode(phy_Control_Field,mu_beta);
[ind_pcc]   = dectPCCind(transmission_modes,mu_beta);
%[ind_pcc]   = dectPCCind(phy_Control_Field,transmission_modes,mu_beta);

[ind_pdc]   = dectPDCind(phy_Control_Field,transmission_modes,mu_beta);

% phy header generation

N_PDC_re = length(ind_pdc);
[N_TB_bits] = dectTransportBlockSize(N_PDC_re,phy_Control_Field,transmission_modes,mu_beta);

% data = randn(1,N_TB_bits)>0;
% estimate the input data packet size 
[pdc_enc_data] = dectPDCEncode( msg_packet, NetworkID, N_PDC_re, phy_Control_Field,transmission_modes,mu_beta);

% modulation 
[pcc_symbols] = dectSymbolMapping(pcc_enc_data,1);
[pdc_symbols] = dectSymbolMapping(pdc_enc_data,phy_Control_Field.DF_MCS);
% mapping to RE
%%
dect_grid = grid_withPilots;
dect_grid(ind_pcc) = pcc_symbols;
dect_grid(ind_pdc) = pdc_symbols;

%%
% ifft + cp
[waveform,info] = dectOFDMModulate(dect_grid,transmission_modes,mu_beta);
% frame construction
tx_frame = [permute(stf,[2 1]); waveform];


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Receiver
% Sync
% Ch estimation  

% Ch estimation  

% PDC demodulation

% Sync
[rx_frame,mu_beta_rx] = dectSync(tx_frame);

% symbol extraction fft
[dect_grid_rx,info] = dectOFDMDemodulate(rx_frame,mu_beta);

% eq
[h_est] = dectChannelEstimate(dect_grid_rx,phy_Control_Field,transmission_modes,mu_beta);
[dect_grid_rx_eq] = dectZeroForcing(dect_grid_rx,h_est,phy_Control_Field,transmission_modes,mu_beta);

% pcc extraction
pcc_re_symbols = dect_grid_rx_eq(ind_pcc);
pcc_soft_symbols = dectSymbolDeMapping(pcc_re_symbols,1);
[pcc_struct] = dectPCCDecode(pcc_soft_symbols);

% data demapping 
N_PDC_re = length(ind_pdc);
pdc_re_symbols = dect_grid_rx_eq(ind_pdc);
MCS = pcc_struct.DF_MCS;
pdc_soft_symbols = dectSymbolDeMapping(pdc_re_symbols,MCS);
[pdc_MACSDU] = dectPDCDecode(pdc_soft_symbols, NetworkID, N_PDC_re, phy_Control_Field,transmission_modes,mu_beta);

% PDC header extraction 
% PDC decoding and extraction

% PCC extraction and decoding
%rx_mac_packet = msg_packet;
rx_mac_packet = double(pdc_MACSDU');


%% PDC Parsing
% addpath('/home/kru/Kru/Proj/DECT/Matlab/Devel/Messages/MAC_message_parsing')  
% addpath('/home/kru/Kru/Proj/DECT/Matlab/Devel/Messages/MAC_message_parsing/MAC_msg_ie_parsers') 
addpath('../MAC_message_parsing')
addpath('../MAC_message_parsing/MAC_msg_ie_parsers')

[rx_mac_header_type_struct] = mac_MAC_Header_Type_extr(rx_mac_packet(1:8));


% select actions based on structure 
switch(rx_mac_header_type_struct.MAC_header_type)
  case 0
    % DATA MAC PDU header as defined in Figure 6.3.3.1-1
    
  case 1
    % Beacon Header as defined in Figure 6.3.3.2-1
    [ rx_network_id, rx_transmitter_address] = mac_Common_Header_Beacon_Header_extr(rx_mac_packet(8+[1:7*8]));
    rx_mac_sdus = rx_mac_packet([65:end]);
  case 2
    % Unicast Header as defined in Figure 6.3.3.3-1
    [ rx_reset, rx_mac_sequence, rx_sequence_number, rx_receiver_address, rx_transmitter_address] = mac_Common_Header_Unicast_Header_extr(rx_mac_packet(8+[1:10*8]));
    rx_mac_sdus = rx_mac_packet([(11*8+1):end]);
  case 3
    % RD Broadcasting Header as defined in Figure 6.3.3.4-1
    
  case 15
    % Escape
    
end

% % parse the packet into sdu
% % 
% [sdu_struct] = mac_SDUs_extraction(rx_mac_sdus);
% 
% % Data decoding 
% ie_len = sdu_struct{1}{1}{3};
% ie_sdu = sdu_struct{1}{1}{4};
% 
% [association_response_msg_ie] = association_response_message_ie_parser(ie_sdu,ie_len)
% 
% ie_len = sdu_struct{2}{1}{3};
% ie_sdu = sdu_struct{2}{1}{4};
% 
% [rd_capability_msg_ie] = rd_capability_ie_parser(ie_sdu,ie_len)


[out_structs] = mac_SDU_parser(rx_mac_sdus);
