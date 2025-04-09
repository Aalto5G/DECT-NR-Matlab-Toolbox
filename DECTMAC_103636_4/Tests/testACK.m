%
% creates ACK/NACK packet
%

% Kalle Ruttik
% 17.11.2023

clear all
close all 

% construct message 


% construct ack 
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

feedback_format1.feedback_format_len = 0;
feedback_format1.HARQ_process_number = 1;
feedback_format1.transmission_feedback = 0;
feedback_format1.buffer_status = 0;
feedback_format1.cqi = 2;


phy_Control_Field = phy_Control_Field2;

%%
% dummy data packet 
% mac_header_type data_sdu
% common_header data_sdu
mac_packet_info = [mac_header_type mac_common_header];
len_msg= length(mac_packet_info);
[N_symb,N_TB_bits] = mac_fit_data_into_min_symbols(len_msg, phy_Control_Field, transmission_modes, mu_beta);
phy_Control_Field.phy_Packet_Length = N_symb;
% padding 
[msg_packet] = mac_add_padding(mac_packet_info, phy_Control_Field,transmission_modes,mu_beta);

% phy message type 21 with feedback format 0

% modulation and packet configuration

% phy


%% 

% n + 3

% allocate message 


% allocate ack 