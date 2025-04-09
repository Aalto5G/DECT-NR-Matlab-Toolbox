%
% Route Info IE message construction
%

% Jaakko Niemistö
% 2.4.2024


function [msg_bin] = route_info_msg_ie_constr(...
    sink_addr,route_cost,app_seq_n)

route_info_msg_struct.sink_addr = 32;
route_info_msg_struct.route_cost = 8;
route_info_msg_struct.app_seq_n = 8;

sink_addr_bin = fliplr(de2bi(double(sink_addr),route_info_msg_struct.sink_addr));
route_cost_bin = fliplr(de2bi(double(route_cost),route_info_msg_struct.route_cost));
app_seq_n_bin = fliplr(de2bi(double(app_seq_n),route_info_msg_struct.app_seq_n));

msg_bin = [sink_addr_bin route_cost_bin app_seq_n_bin];

% Header type d)
ie_type = [0 1 0 0 0 1]; % route info message type 
len = length(msg_bin);
mac_mux_pdu = mac_mux_header_d_constr(ie_type, len);

msg_bin = [mac_mux_pdu msg_bin];

end 
