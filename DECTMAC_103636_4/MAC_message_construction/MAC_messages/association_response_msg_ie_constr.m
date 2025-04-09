%
% association_response_msg construction
%

% Kalle Ruttik
% 27.10.2023


function [msg_bin] = association_response_msg_ie_constr(ack_nack,HARQ_mod,Number_of_flows,Group,Tx_power,Reject_cause,Reject_time,HARQ_processes_RX,MAX_HARQ_Re_RX,HARQ_processes_TX,MAX_HARQ_Re_TX,Flow_ID,group_ID,Resource_tag);

% ie type defines the length of the ie payload
% type c) without length indication
ie_type = [0 0 1 0 1 1];
mac_extension_field_encoding = [0 1];
mac_mux_pdu = [mac_extension_field_encoding ie_type];

% clear all
% 
% ack_nack = 0;
% HARQ_mod = 0;
% Number_of_flows = 0;
% Group = 0;
% Tx_power = 0;
% Reject_cause = 0;
% Reject_time = 0;
% HARQ_processes_RX = 0;
% MAX_HARQ_Re_RX = 0;
% HARQ_processes_TX = 0;
% MAX_HARQ_Re_TX = 0;
% Flow_ID = 0;
% group_ID = 0;
% Resource_tag = 0;

association_response_msg.ack_nack_len = 1;
association_response_msg.HARQ_mod_len = 1;
association_response_msg.Number_of_flows_len = 3;
association_response_msg.Group_len = 1;
association_response_msg.Tx_power_len = 1;
association_response_msg.Reject_cause_len = 4;
association_response_msg.Reject_time_len = 4;
association_response_msg.HARQ_processes_RX_len = 3;
association_response_msg.MAX_HARQ_Re_RX_len = 5;
association_response_msg.HARQ_processes_TX_len = 3;
association_response_msg.MAX_HARQ_Re_TX_len = 5;
association_response_msg.Flow_ID_len = 6;
association_response_msg.group_ID_len = 7;
association_response_msg.Resource_tag_len = 7;

ack_nack_bin = fliplr(de2bi(double(ack_nack),association_response_msg.ack_nack_len));
reserver_bin = 0;
HARQ_mod_bin = fliplr(de2bi(double(HARQ_mod),association_response_msg.HARQ_mod_len));
Number_of_flows_bin =  fliplr(de2bi(double(Number_of_flows),association_response_msg.Number_of_flows_len));
Group_bin =  fliplr(de2bi(double(Group),association_response_msg.Group_len));
Tx_power_bin =  fliplr(de2bi(double(Tx_power),association_response_msg.Tx_power_len));

msg_bin = [ack_nack_bin reserver_bin HARQ_mod_bin Number_of_flows_bin Group_bin Tx_power_bin]; 


% if rejected
if ack_nack == 0
 Reject_cause_bin =  fliplr(de2bi(double(Reject_cause),association_response_msg.Reject_cause_len));
 Reject_time_bin =  fliplr(de2bi(double(Reject_time),association_response_msg.Reject_time_len));
 msg_bin = [msg_bin Reject_cause_bin Reject_time_bin];
end

% accepted 
if HARQ_mod == 1
HARQ_processes_RX_bin =  fliplr(de2bi(double(HARQ_processes_RX),association_response_msg.HARQ_processes_RX_len));
MAX_HARQ_Re_RX_bin =  fliplr(de2bi(double(MAX_HARQ_Re_RX),association_response_msg.MAX_HARQ_Re_RX_len));
HARQ_processes_TX_bin =  fliplr(de2bi(double(HARQ_processes_TX),association_response_msg.HARQ_processes_TX_len));
MAX_HARQ_Re_TX_bin =  fliplr(de2bi(double(MAX_HARQ_Re_TX),association_response_msg.MAX_HARQ_Re_TX_len));

msg_bin = [msg_bin HARQ_processes_RX_bin MAX_HARQ_Re_RX_bin HARQ_processes_TX_bin MAX_HARQ_Re_TX_bin];
end

reserved2_bin = fliplr(de2bi(0,2));
Flow_ID_bin =  fliplr(de2bi(double(Flow_ID),association_response_msg.Flow_ID_len));
msg_bin = [msg_bin reserved2_bin Flow_ID_bin];


if Group == 1
  reserved3_bin = fliplr(de2bi(0,1));
  group_ID_bin =  fliplr(de2bi(double(group_ID),association_response_msg.group_ID_len));
  reserved4_bin = fliplr(de2bi(0,1));
  Resource_tag_bin =  fliplr(de2bi(double(Resource_tag),association_response_msg.Resource_tag_len));
  msg_bin = [msg_bin reserved3_bin group_ID_bin reserved4_bin Resource_tag_bin];
end

% if ack_nack == 1
%  reserved4_bin = fliplr(de2bi(0,1));
%  Resource_tag_bin =  fliplr(de2bi(double(Resource_tag),association_response_msg.Resource_tag_len));
%  msg_bin = [msg_bin reserved4_bin Resource_tag_bin];
% end


% adding the header to the binary data
len = length(msg_bin);
len_bin = fliplr(de2bi(len,8));
msg_bin = [mac_mux_pdu len_bin msg_bin];

end