%
% Generates PHY messages and sends to UDP server 
% 

% Kalle Ruttik
% 13.09.2023


%% reset
clc;
clear all;
close all;

addpath('./DECTMAC_103636_4/MAC_message_construction');
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
phy_Control_Field1.transmit_Power = 2;          % 4 bits 
phy_Control_Field1.reserved = 0;                % 1 bit 
phy_Control_Field1.DF_MCS = 1;                  % 3 bits. PDC MCS. 

% create the binary packet 
tmpData = [0 0 0 0 0 0 0 phy_Control_Field1.Type];
%tmpData = [0 0 0 0 0 0 0 0];
phyMsg1(1) = uint8(bi2de(fliplr(tmpData))); %dec2bin(tmpData);
tmpData = [phy_Control_Field1.header_format phy_Control_Field1.Packet_Length_Type fliplr(de2bi(phy_Control_Field1.phy_Packet_Length,4))];
phyMsg1(2) = uint8(bi2de(fliplr(tmpData))); %num2str();
phyMsg1(3) = uint8(phy_Control_Field1.short_Network_ID);
tmp = dec2hex(phy_Control_Field1.transmitter_Identity,4);
phyMsg1(4) = uint8(hex2dec(tmp([1:2])));
phyMsg1(5) = uint8(hex2dec(tmp([3:4])));
tmpData = [fliplr(de2bi(phy_Control_Field1.transmit_Power,4)) phy_Control_Field1.reserved fliplr(de2bi(phy_Control_Field1.DF_MCS,3))];
phyMsg1(6) = uint8(bi2de(fliplr(tmpData)));

phyMsg_trimmed = phyMsg1(2:end);

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

% create the binary packet 
tmpData = [0 0 0 0 0 0 fliplr(de2bi(phy_Control_Field2.Type,2))];
phyMsg2(1) = uint8(bi2de(fliplr(tmpData))); %dec2bin(tmpData);
tmpData = [phy_Control_Field2.header_format phy_Control_Field2.Packet_Length_Type fliplr(de2bi(phy_Control_Field2.phy_Packet_Length,4))];
phyMsg2(2) = uint8(bi2de(fliplr(tmpData))); %num2str();
phyMsg2(3) = uint8(phy_Control_Field2.short_Network_ID);
tmp = dec2hex(phy_Control_Field2.transmitter_Identity,4);
phyMsg2(4) = uint8(hex2dec(tmp([1:2])));
phyMsg2(5) = uint8(hex2dec(tmp([3:4])));
tmpData = [fliplr(de2bi(phy_Control_Field2.transmit_Power,4)) fliplr(de2bi(phy_Control_Field2.DF_MCS,4))];
phyMsg2(6) = uint8(bi2de(fliplr(tmpData))); 
tmp = dec2hex(phy_Control_Field2.Receiver_Identity,4);
phyMsg2(7) = uint8(hex2dec(tmp([1:2])));
phyMsg2(8) = uint8(hex2dec(tmp([3:4])));

tmpData = [fliplr(de2bi(phy_Control_Field2.Number_of_Spatial_Streams,2)) fliplr(de2bi(phy_Control_Field2.DF_Redundancy_Version,2)) ...
  fliplr(de2bi(phy_Control_Field2.New_Data_Indicator,1)) fliplr(de2bi(phy_Control_Field2.DF_HARQ_Process_Number,3))];
phyMsg2(9) = uint8(bi2de(fliplr(tmpData))); 

tmpData = [fliplr(de2bi(phy_Control_Field2.Feedback_Format,4)) fliplr(de2bi(phy_Control_Field2.Feedback_Info,12))];
tmp = dec2hex(bi2de(fliplr(tmpData)),4);
phyMsg2(10) = uint8(hex2dec(tmp([1:2])));
phyMsg2(11) = uint8(hex2dec(tmp([3:4])));

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


% create the binary packet 
tmpData = [0 0 0 0 0 0 fliplr(de2bi(phy_Control_Field21.Type,2))];
phyMsg3(1) = uint8(bi2de(fliplr(tmpData))); %dec2bin(tmpData);
tmpData = [phy_Control_Field21.header_format phy_Control_Field21.Packet_Length_Type fliplr(de2bi(phy_Control_Field21.phy_Packet_Length,4))];
phyMsg3(2) = uint8(bi2de(fliplr(tmpData))); %num2str();
phyMsg3(3) = uint8(phy_Control_Field21.short_Network_ID);
tmp = dec2hex(phy_Control_Field21.transmitter_Identity,4);
phyMsg3(4) = uint8(hex2dec(tmp([1:2])));
phyMsg3(5) = uint8(hex2dec(tmp([3:4])));
tmpData = [fliplr(de2bi(phy_Control_Field21.transmit_Power,4)) fliplr(de2bi(phy_Control_Field21.DF_MCS,4))];
phyMsg3(6) = uint8(bi2de(fliplr(tmpData))); 
tmp = dec2hex(phy_Control_Field21.Receiver_Identity,4);
phyMsg3(7) = uint8(hex2dec(tmp([1:2])));
phyMsg3(8) = uint8(hex2dec(tmp([3:4])));

tmpData = [fliplr(de2bi(phy_Control_Field21.Number_of_Spatial_Streams,2)) fliplr(de2bi(phy_Control_Field21.reserved,6))];
phyMsg3(9) = uint8(bi2de(fliplr(tmpData))); 

tmpData = [fliplr(de2bi(phy_Control_Field21.Feedback_Format,4)) fliplr(de2bi(phy_Control_Field21.Feedback_Info,12))];
tmp = dec2hex(bi2de(fliplr(tmpData)),4);
phyMsg3(10) = uint8(hex2dec(tmp([1:2])));
phyMsg3(11) = uint8(hex2dec(tmp([3:4])));

%%
% addpath('../../decttoolbox/DECTPHY_103636_3')  
% 
% phyMsg11 = dectPCCSerializer(phy_Control_Field1);
% phyMsg21 = dectPCCSerializer(phy_Control_Field2);
% phyMsg31 = dectPCCSerializer(phy_Control_Field21);
%% MAC Header type
macHeaderType_dataMACPDU_bin = mac_MAC_Header_Type_constr(0,0,0);
macHeaderType_dataMACPDU(1) = uint8(bi2de(fliplr(macHeaderType_dataMACPDU_bin)));

macHeaderType_beacon_bin = mac_MAC_Header_Type_constr(0,0,1);
macHeaderType_beacon(1) = uint8(bi2de(fliplr(macHeaderType_beacon_bin)));

macHeaderType_unicast_bin = mac_MAC_Header_Type_constr(0,0,2);
macHeaderType_unicast(1) = uint8(bi2de(fliplr(macHeaderType_unicast_bin)));

macHeaderType_RDBroadcasting_bin = mac_MAC_Header_Type_constr(0,0,3);
macHeaderType_RDBroadcasting(1) = uint8(bi2de(fliplr(macHeaderType_RDBroadcasting_bin)));

%% MAC Common Header
% DATA MAC PDU Header
% total length 2 bytes
% reset length 1
% sequence number length 12
macCommonHeader_dataMACPDU_bin = ...
    mac_Common_Header_DATA_MAC_PDU_Header_constr(0,4095);
macCommonHeader_dataMACPDU = ...
    binMsg2unit8Converter(macCommonHeader_dataMACPDU_bin, 2);

% Beacon Header
% total length 7 bytes
% network id length 24
% transmitter address length 32
macCommonHeader_beacon_bin = ...
    mac_Common_Header_Beacon_Header_constr(12345678, 4294967295);
macCommonHeader_beacon = ...
    binMsg2unit8Converter(macCommonHeader_beacon_bin, 7);

% Unicast Header
% total length 10 bytes
% reset length 1
% mac sequence length 4
% sequence number length 8
% receiver address length 32
% transmitter address length 32
macCommonHeader_unicast_bin = ...
    mac_Common_Header_Unicast_Header_constr(0,15,255,4294967295,4294967295);
macCommonHeader_unicast = ...
    binMsg2unit8Converter(macCommonHeader_unicast_bin, 10);

% RD Broadcasting Header
% total length 6 bytes
% reset length 1
% sequence number length 12
% transmitter address length 32
macCommonHeader_RDBroadcasting_bin = ...
    mac_Common_Header_RD_Broadcasting_Header_constr(0,4095,4294967295);
macCommonHeader_RDBroadcasting = ...
    binMsg2unit8Converter(macCommonHeader_RDBroadcasting_bin, 6);


%% MAC message
macMsg_dataMACPDU       = [macHeaderType_dataMACPDU macCommonHeader_dataMACPDU];
macMsg_beacon           = [macHeaderType_beacon macCommonHeader_beacon];
macMsg_unicast          = [macHeaderType_unicast macCommonHeader_unicast];
macMsg_RDBroadcasting   = [macHeaderType_RDBroadcasting macCommonHeader_RDBroadcasting];

%% PHY + MAC
dectMsg_dataMACPDU      = [phyMsg_trimmed macMsg_dataMACPDU];
dectMsg_beacon          = [phyMsg_trimmed macMsg_beacon];
dectMsg_unicast         = [phyMsg_trimmed macMsg_unicast];
dectMsg_RDBroadcasting  = [phyMsg_trimmed macMsg_RDBroadcasting];

%% MAC MUX + SDU
addpath('./MAC_message_construction/MAC_MUX_headers/');
addpath('./MAC_message_construction/MAC_messages/');

% % % SDUs
% % MAC messages

% network_beacon_message_bin = network_beacon_msg_ie_constr(1,0,1,1,2,3,24,5000,9,25,23);
% network_beacon_message_len = length(network_beacon_message_bin) / 8;
% network_beacon_message = binMsg2unit8Converter(network_beacon_message_bin, network_beacon_message_len);
% dectMsg_beaconMsg = [ dectMsg_beacon network_beacon_message ];



% cluster_beacon_message_bin = cluster_beacon_msg_ie_constr();
% association_request_message_bin = association_request_msg_ie_constr();
% association_response_message_bin = association_response_msg_ie_constr();
% association_release_message_bin = association_release_msg_ie_constr();

% reconfiguration_request_msg_bin = reconfiguration_request_msg_ie_constr(1,1,0,3,0,1,2,3,4,[0 1 0],[11 22 33]);
% reconfiguration_request_msg_len = length(reconfiguration_request_msg_bin) / 8;
% reconfiguration_request_msg = binMsg2unit8Converter(reconfiguration_request_msg_bin, reconfiguration_request_msg_len);
% dectMsg_reconReq = [ dectMsg_beacon reconfiguration_request_msg ];

% reconfiguration_response_msg_bin = reconfiguration_response_msg_ie_constr(1,1,0,3,0,1,2,3,4,[0 1 0],[11 22 33]);
% reconfiguration_response_msg_len = length(reconfiguration_response_msg_bin) / 8;
% reconfiguration_response_msg = binMsg2unit8Converter(reconfiguration_response_msg_bin, reconfiguration_response_msg_len);
% dectMsg_reconResp = [ dectMsg_beacon reconfiguration_response_msg ];

%network_beacon_message_bin = network_beacon_msg_ie_constr(1,0,1,1,2,3,24,5000,9,25,23);
%network_beacon_message_len = length(network_beacon_message_bin) / 8;
%network_beacon_message = binMsg2unit8Converter(network_beacon_message_bin, network_beacon_message_len);
%dectMsg_beaconMsg = [ dectMsg_beacon network_beacon_message ];

%cluster_beacon_message_bin = cluster_beacon_msg_ie_constr(0,1,1,1,1,1,3,2,5,3,2,14,10,24,4444);
%cluster_beacon_message_len = length(cluster_beacon_message_bin) / 8;
%cluster_beacon_message = binMsg2unit8Converter(cluster_beacon_message_bin, cluster_beacon_message_len);
%dectMsg_beaconMsg = [ dectMsg_beacon cluster_beacon_message ];

% association_request_message_bin = association_request_msg_ie_constr(0,5,0,1,0,6,15,7,5,1,15,13,345,12345,345);
% association_request_message_len = length(association_request_message_bin) / 8;
% association_request_message = binMsg2unit8Converter(association_request_message_bin, association_request_message_len);
% dectMsg_beaconMsg = [ dectMsg_beacon association_request_message ];

% association_response_message_bin = association_response_msg_ie_constr(0,1,5,1,1,7,4,5,3,6,4,15,123,111);
% association_response_message_len = length(association_response_message_bin) / 8;
% association_response_message = binMsg2unit8Converter(association_response_message_bin, association_response_message_len);
% dectMsg_beaconMsg = [ dectMsg_beacon association_response_message ];

% association_release_message_bin = association_release_msg_ie_constr(15);
% association_release_message_len = length(association_release_message_bin) / 8;
% association_release_message = binMsg2unit8Converter(association_release_message_bin, association_release_message_len);
% dectMsg_beaconMsg = [ dectMsg_beacon association_release_message ];
% reconfiguration_request_message_bin = reconfiguration_request_msg_ie_constr();
% reconfiguration_response_message_bin = reconfiguration_response_msg_ie_constr();

% % MAC information elements
% mac_security_info_ie_bin = mac_security_info_msg_ie_constr(0, 1, 2, 123456);
% mac_security_info_ie_len = length(mac_security_info_ie_bin) / 8;
% mac_security_info_ie_msg = binMsg2unit8Converter(mac_security_info_ie_bin, mac_security_info_ie_len);
% dectMsg_macSecInfo = [ dectMsg_beacon mac_security_info_ie_msg ];

% route_info_ie_bin = route_info_msg_ie_constr(2^32-1,55,123);
% route_info_ie_len = length(route_info_ie_bin) / 8;
% route_info_ie_msg = binMsg2unit8Converter(route_info_ie_bin, route_info_ie_len);
% dectMsg_routeInfo = [ dectMsg_beacon route_info_ie_msg ];

resource_allocation_ie_bin = resource_allocation_ie_constr(2^2-1,1,1,2^3-1,1,1,1,2^8-1,1,2^7-1,2^8-1,1,2^7-1,2^16-1,2^8-1,2^8-1,2^8-1,2^13-1,2^4-1);
resource_allocation_ie_len = length(resource_allocation_ie_bin) / 8;
resource_alloccation_ie_msg = binMsg2unit8Converter(resource_allocation_ie_bin, resource_allocation_ie_len);
dectMsg_resource_allocation = [ dectMsg_beacon resource_alloccation_ie_msg ];

%random_access_resource_ie_bin = random_access_resource_ie_constr(2^2-1,1,1,1,2^8-1,1,2^7-1,1,2^4-1,2^3-1,1,2^4-1,2^3-1,2^8-1,2^8-1,2^8-1,2^13-1,2^13-1);
%random_access_resource_ie_len = length(random_access_resource_ie_bin) / 8;
%random_access_resource_ie_msg = binMsg2unit8Converter(random_access_resource_ie_bin, random_access_resource_ie_len);
%dectMsg_random_access_resource = [ dectMsg_beacon random_access_resource_ie_msg ];

%rd_capability_ie_bin = rd_capability_ie_constr(2^3-1,2^5-1,1,1,2^2-1,1,1,2^3-1,2^3-1,2^3-1,2^2-1,2^2-1,2^4-1,2^4-1,2^4-1,2^2-1,2^4-1,1,1,2^3-1,2^4-1,2^3-1,2^2-1,2^2-1,2^4-1,2^4-1,2^4-1,2^2-1,2^4-1);
%rd_capability_ie_len = length(rd_capability_ie_bin) / 8;
%rd_capability_ie_msg = binMsg2unit8Converter(rd_capability_ie_bin, rd_capability_ie_len);
%dectMsg_rd_capability = [ dectMsg_beacon rd_capability_ie_msg ];

%neighbouring_ie_bin = neighbouring_ie_msg_constr(1,1,1,1,1,1,1,2^4-1,2^4-1,2^32-1,2^13-1,2^32-1,2^8-1,2^8-1,2^3-1,2^4-1);
%neighbouring_ie_len = length(neighbouring_ie_bin) / 8;
%neighbouring_ie_msg = binMsg2unit8Converter(neighbouring_ie_bin, neighbouring_ie_len);
%dectMsg_neighbouring = [ dectMsg_beacon neighbouring_ie_msg ];

%broadcast_indication_ie_bin = broadcast_indication_msg_ie_constr(1,0,1,2,0,65535,191);
%broadcast_indication_ie_len = length(broadcast_indication_ie_bin) / 8;
%broadcast_indication_ie_msg = binMsg2unit8Converter(broadcast_indication_ie_bin, broadcast_indication_ie_len);
%dectMsg_broadcast_indication = [ dectMsg_beacon broadcast_indication_ie_msg ];

% padding_ie_bin = padding_ie_msg_constr();
% group_assignment_ie_bin = group_assignment_msg_ie_constr();

%load_info_ie_bin = load_info_msg_ie_constr(0,1,1,1,33,15,8,2,25,6,9);
%load_info_ie_len = length(load_info_ie_bin) / 8;
%load_info_ie_msg = binMsg2unit8Converter(load_info_ie_bin, load_info_ie_len);
%dectMsg_loadInfo = [ dectMsg_beacon load_info_ie_msg ];

% MUX Headers testing

% mux_sdu_A_bin = mac_mux_header_a_constr(3,1,2^5-1);
% mux_sdu_A = binMsg2unit8Converter(mux_sdu_A_bin, 1);
% 
% mux_sdu_B_bin = mac_mux_header_b_constr(3,1,2^5-1, [1 0 1 0 1 0 1 0]);
% mux_sdu_B = binMsg2unit8Converter(mux_sdu_B_bin, 2);
% 
% mux_sdu_C_bin = mac_mux_header_c_constr(2^6-1, [1 0 1 0 1 0 1 0]);
% mux_sdu_C = binMsg2unit8Converter(mux_sdu_C_bin, length(mux_sdu_C_bin)/8);
% 
% mux_sdu_D_bin = mac_mux_header_d_constr(2^6-1, 1, [1 0 1 0 1 0 1 0]);
% mux_sdu_D = binMsg2unit8Converter(mux_sdu_D_bin, length(mux_sdu_D_bin)/8)
% 
% mux_sdu_E_bin = mac_mux_header_e_constr(2^6-1, 1, [1 0 1 0 1 0 1 0]);
% mux_sdu_E = binMsg2unit8Converter(mux_sdu_E_bin, length(mux_sdu_E_bin)/8);
% 
% mux_sdu_F_bin = mac_mux_header_f_constr(2, 2^6-1, 0, 2^8-1, [1 0 1 0 1 0 1 0]);
% mux_sdu_F = binMsg2unit8Converter(mux_sdu_F_bin, length(mux_sdu_F_bin)/8);

%% UDP transmission
% message transmission to a udp port 
ADDRESS = "127.0.0.1"; % localhost
PORT = 8091  % port of this server
u = udpport() %"datagram","IPV4","LocalPort", PORT)

% write(u,data,datatype,destinationAddress,destinationPort)
% write(u,dectMsg_dataMACPDU,"uint8",ADDRESS,PORT);
% dectMsg_dataMACPDU
% write(u,dectMsg_beacon,"uint8",ADDRESS,PORT);
% dectMsg_beacon
% write(u,dectMsg_unicast,"uint8",ADDRESS,PORT);
% dectMsg_unicast
% write(u,dectMsg_RDBroadcasting,"uint8",ADDRESS,PORT);
% dectMsg_RDBroadcasting

% write(u,phyMsg1,"uint8",ADDRESS,PORT);
% phyMsg1
% write(u,phyMsg2,"uint8",ADDRESS,PORT);
% phyMsg2
% write(u,phyMsg3,"uint8",ADDRESS,PORT);
% phyMsg3

% TEST WRITES FOR WIRESHARK GO HERE.
write(u,dectMsg_resource_allocation,"uint8",ADDRESS,PORT);
dectMsg_resource_allocation

%write(u,dectMsg_random_access_resource,"uint8",ADDRESS,PORT);
%dectMsg_random_access_resource

%write(u,dectMsg_rd_capability,"uint8",ADDRESS,PORT)
%dectMsg_rd_capability

%write(u,dectMsg_neighbouring,"uint8",ADDRESS,PORT)
%dectMsg_neighbouring

%write(u,dectMsg_broadcast_indication,"uint8",ADDRESS,PORT);
%dectMsg_broadcast_indication