%
% Load Info IE message construction
%

% Jaakko Niemistö
% 5.4.2024


function [msg_bin] = load_info_msg_ie_constr(...
    max_assoc,rd_pt_load,rach_load,channel_load,...
    traffic_load_percentage,max_number_associated_RDs,...
    current_RDs_FT,current_RDs_PT,rach_load_perc,subslots_free,subslots_busy)

load_info_msg_struct.max_assoc = 1;
load_info_msg_struct.rd_pt_load = 1;
load_info_msg_struct.rach_load = 1;
load_info_msg_struct.channel_load = 1;
load_info_msg_struct.traffic_load_percentage = 8;
load_info_msg_struct.max_number_associated_RDs_0 = 8;
load_info_msg_struct.max_number_associated_RDs_1 = 16;
load_info_msg_struct.current_RDs_FT = 8;
load_info_msg_struct.current_RDs_PT = 8;
load_info_msg_struct.rach_load_perc = 8;
load_info_msg_struct.subslots_free = 8;
load_info_msg_struct.subslots_busy = 8;

reserved_bin  = fliplr(de2bi(double(0),4));
max_assoc_bin = fliplr(de2bi(double(max_assoc),load_info_msg_struct.max_assoc));
rd_pt_load_bin = fliplr(de2bi(double(rd_pt_load),load_info_msg_struct.rd_pt_load));
rach_load_bin = fliplr(de2bi(double(rach_load),load_info_msg_struct.rach_load));
channel_load_bin = fliplr(de2bi(double(channel_load),load_info_msg_struct.channel_load));
traffic_load_percentage_bin = fliplr(de2bi(double(traffic_load_percentage),load_info_msg_struct.traffic_load_percentage));

msg_bin = [reserved_bin max_assoc_bin rd_pt_load_bin rach_load_bin channel_load_bin traffic_load_percentage_bin];

if max_assoc == 0
    max_number_associated_RDs_bin = fliplr(de2bi(double(max_number_associated_RDs),load_info_msg_struct.max_number_associated_RDs_0));
else
    max_number_associated_RDs_bin = fliplr(de2bi(double(max_number_associated_RDs),load_info_msg_struct.max_number_associated_RDs_1));
end

msg_bin = [msg_bin max_number_associated_RDs_bin];

current_RDs_FT_bin = fliplr(de2bi(double(current_RDs_FT),load_info_msg_struct.current_RDs_FT));
msg_bin = [msg_bin current_RDs_FT_bin];

if rd_pt_load == 1
    current_RDs_PT_bin = fliplr(de2bi(double(current_RDs_PT),load_info_msg_struct.current_RDs_PT));
    msg_bin = [msg_bin current_RDs_PT_bin];
end

if rach_load == 1
    rach_load_perc_bin = fliplr(de2bi(double(rach_load_perc),load_info_msg_struct.rach_load_perc));
    msg_bin = [msg_bin rach_load_perc_bin];
end

if channel_load == 1
    subslots_free_bin = fliplr(de2bi(double(subslots_free),load_info_msg_struct.subslots_free));
    subslots_busy_bin = fliplr(de2bi(double(subslots_busy),load_info_msg_struct.subslots_busy));
    msg_bin = [msg_bin subslots_free_bin subslots_busy_bin];
end

% Header type d)
ie_type = [0 1 1 0 0 0]; % load info ie message type 
len = length(msg_bin);
mac_mux_pdu = mac_mux_header_d_constr(ie_type, len);

msg_bin = [mac_mux_pdu msg_bin];

end 