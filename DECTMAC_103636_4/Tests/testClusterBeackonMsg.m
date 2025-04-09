%
% Network beacon message generation 
%

% Kalle Ruttik 
% 27.10.2023

clear all 

% addpath(genpath([fileparts(fileparts(pwd)), filesep, 'YourCode.m' ]));


%addpath("./DECTPHY_103636_3")
% pathMacHeaderGenerator = "./../Messages/MAC_message_construction";
% pathMacMsgGenerator = "../Messages/MAC_message_contruction/MAC_messages";
%addpath(pathMacHeaderGenerator);
%addpath(pathMacMsgGenerator);

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
phy_Control_Field21.Packet_Length_Type = 1;      % 1 bit. length given in slots 
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
%addpath('/home/kru/Kru/Proj/DECT/Matlab/decttoolbox/DECTPHY_103636_3')  
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

%% Broadcasted Cluster header 
%addpath('/home/kru/Kru/Proj/DECT/Matlab/Devel/Messages/MAC_message_construction')  
addpath('../MAC_message_construction')  
addpath('../MAC_message_construction/MAC_messages')  

% mac_Beacon_header_construction
tmp_network_id_dec = 19001;
tmp_transmitter_address_dec = 300001;

% mac header type: Beacon header
version = 0;
mac_security = 0;  % not used 
beacon_header = 1; % beacon header type
[mac_header_type] = mac_MAC_Header_Type_constr(version,mac_security,beacon_header);

% mac common header: Beacon header 
network_id               = tmp_network_id_dec;
transmitter_address      = tmp_transmitter_address_dec;
[mac_common_header] = mac_Common_Header_Beacon_Header_constr( network_id, transmitter_address);

% cluster beacon ie
sfn = 1;
Tx_power = 0;
Power_const = 0;
fo = 0;
next_channel = 0;
TimeToNext = 1;

network_beacon_period = 0;
cluster_beacon_period = 0;

count_to_trigger = 0;
rel_quality = 0;
min_quality = 0;
cluster_max_tx_power = 0;
frame_offset = 0;

next_cluster_channel=0;
time_to_next = 10;

% header and  msg ie generation
[cluster_beacon_msg_ie] = cluster_beacon_msg_ie_constr(sfn,Tx_power, Power_const, fo, next_channel, TimeToNext,...
  network_beacon_period, cluster_beacon_period, count_to_trigger, ...
  rel_quality, min_quality, cluster_max_tx_power, frame_offset, next_cluster_channel, time_to_next);

% combining mac message
mac_packet_info = [mac_header_type mac_common_header cluster_beacon_msg_ie];

%% random access resource ie
random_access_resource_msg_ie = [];

Repeat = 0;
SFN = 0;
Channel = 0;
Channel_2 = 0;
 
Start_subslot = 1;
Length_type = 0;
Length = 1;
MAX_len_type = 0;
MAX_RACH_Length = 0;

CW_min_sig = 0;
DECT_delay = 0;
response_window = 0;
CW_max_sig = 0;
repetition = 0;
validity = 0; 
SFN_offset = 0;
channel1 = 0;
channel2 = 0;

[random_access_resource_msg_ie] = random_access_resource_ie_constr(Repeat,SFN,Channel,Channel_2,Start_subslot,Length_type, Length,MAX_len_type,MAX_RACH_Length,CW_min_sig,...
  DECT_delay,response_window,CW_max_sig,repetition,validity,SFN_offset,channel1,channel2)


mac_packet_info = [mac_header_type mac_common_header cluster_beacon_msg_ie random_access_resource_msg_ie];

% padding 
[msg_packet] = mac_add_padding(mac_packet_info, phy_Control_Field,transmission_modes,mu_beta);

% encoding





% phy header generation

% modulation 

%%
% Receiver
% Sync
% Ch estimation  
% PDC demodulation
% PDC header extraction 
% PDC decoding and extraction

% PCC extraction and decoding
rx_mac_packet = msg_packet;
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
% ie_sdu = sdu_struct{1}{1}{4};
% [rx_cluster_beacon_message_ie1] = cluster_beacon_message_ie_parser(ie_sdu)
% 
% ie_sdu2 = sdu_struct{2}{1}{4};
% [rx_random_access_resource_msg_ie] = random_access_resource_ie_parser(ie_sdu2)


[out_structs] = mac_SDU_parser(rx_mac_sdus);