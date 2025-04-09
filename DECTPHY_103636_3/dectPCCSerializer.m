%
% encodes PCC message into uint8 binary format
%
% [pcc_bin] = dectPCC(phy_Control_Field,mu_beta)
%
% endodes the control channel with channel coding and scramblest it
%

% Kalle Ruttik
% 8.2.2024

%%
% select 40 or 80 bits 
% output uint8
function [pcc_bin] = dectPCCSerializer(phy_Control_Field)

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
    len = 5;
  case 2
    msg = [];
    header_format = bi2de(fliplr(phy_Control_Field.header_format));
    len = 10;
    switch header_format 
      case 0
        msg = [msg phy_Control_Field.header_format];
        msg = [msg fliplr(de2bi(phy_Control_Field.Packet_Length_Type,1))];     % 1 bit. length given in slots 
        msg = [msg fliplr(de2bi(phy_Control_Field.phy_Packet_Length,4))];      % 4 bits.
        msg = [msg fliplr(de2bi(phy_Control_Field.short_Network_ID,8))];       % NetworkID&0x000000FF;      % 8 bits defined in 4.2.3.1   
        msg = [msg fliplr(de2bi(phy_Control_Field.transmitter_Identity,16))];  % 16 bits. RD ID. def. in 4.2.3.3
        msg = [msg fliplr(de2bi(phy_Control_Field.transmit_Power,4))];         % 4 bits 
        msg = [msg fliplr(de2bi(phy_Control_Field.DF_MCS,4))];                 % 4 bits. PDC MCS.
        msg = [msg fliplr(de2bi(phy_Control_Field.Receiver_Identity,16))];     % 16 bits. RD ID. def. in 4.2.3.3
        msg = [msg fliplr(de2bi(phy_Control_Field.Number_of_Spatial_Streams,2))]; % 2 bits. RD ID. def. in 6.2.1-4
        msg = [msg fliplr(de2bi(phy_Control_Field.DF_Redundancy_Version,2))];  % 2 bits. Packet redundancy version. def. 636-3 in 6.1.5-4
        msg = [msg fliplr(de2bi(phy_Control_Field.New_Data_Indicator,1))];     % 1 bits. HARQ combination info
        msg = [msg fliplr(de2bi(phy_Control_Field.DF_HARQ_Process_Number,3))]; % 3 bits. HARQ process nr
        msg = [msg fliplr(de2bi(phy_Control_Field.Feedback_Format,4))];        % 4 bits. Feedback Info coding Table 6.2.2-1
        msg = [msg fliplr(de2bi(phy_Control_Field.Feedback_Info,12))];         % 12 bits. Feedback Info coding Table 6.2.2-1 
      case 1
        msg = [msg phy_Control_Field.header_format];                           % 3 bit. format
        msg = [msg fliplr(de2bi(phy_Control_Field.Packet_Length_Type,1))];     % 1 bit. length given in slots 
        msg = [msg fliplr(de2bi(phy_Control_Field.phy_Packet_Length,4))];      % 4 bits.
        msg = [msg fliplr(de2bi(phy_Control_Field.short_Network_ID,8))];       % NetworkID&0x000000FF;      % 8 bits defined in 4.2.3.1   
        msg = [msg fliplr(de2bi(phy_Control_Field.transmitter_Identity,16))];  % 16 bits. RD ID. def. in 4.2.3.3
        msg = [msg fliplr(de2bi(phy_Control_Field.transmit_Power,4))];         % 4 bits 
        msg = [msg fliplr(de2bi(phy_Control_Field.DF_MCS,4))];                 % 4 bits. PDC MCS.
        msg = [msg fliplr(de2bi(phy_Control_Field.Receiver_Identity,16))];     % 16 bits. RD ID. def. in 4.2.3.3
        msg = [msg fliplr(de2bi(phy_Control_Field.Number_of_Spatial_Streams,2))]; % 2 bits. RD ID. def. in 6.2.1-4
        msg = [msg fliplr(de2bi(phy_Control_Field.reserved,6))];               % 6 bits. Packet redundancy version. def. 636-3 in 6.1.5-4
        msg = [msg fliplr(de2bi(phy_Control_Field.Feedback_Format,4))];        % 4 bits. Feedback Info coding Table 6.2.2-1
        msg = [msg fliplr(de2bi(phy_Control_Field.Feedback_Info,12))];         % 12 bits. Feedback Info coding Table 6.2.2-1 
        
    end
    
end

pcc_bin = [];
tmpData = [0 0 0 0 0 0 fliplr(de2bi(msgType,2))];
pcc_bin(1) = uint8(bi2de(fliplr(tmpData)));
pcc_bin(2:(len+1))= uint8(bi2de(fliplr((reshape(msg,8,len)'))));

end % function