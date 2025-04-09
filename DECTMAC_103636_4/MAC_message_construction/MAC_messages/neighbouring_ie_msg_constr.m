%
% Neighbouring IE message construction
%

% Jaakko Niemistö
% 5.4.2024


function [msg_bin] = neighbouring_ie_msg_constr(...
    ID ,mu_i,snr_i,rssi2_i,power_const,next_channel_i,time_to_next_i,...
    network_beacon_period,cluster_beacon_period, Long_RD_id,...
    next_cluster_channel,time_to_next_v,...
    rsi2_v,snr_v,mu_v,beta_v)


neighbouring_ie_msg_struct.ID = 1;
neighbouring_ie_msg_struct.mu_i = 1;
neighbouring_ie_msg_struct.snr_i = 1;
neighbouring_ie_msg_struct.rssi2_i = 1;
neighbouring_ie_msg_struct.power_const = 1;
neighbouring_ie_msg_struct.next_channel_i = 1;
neighbouring_ie_msg_struct.time_to_next_i = 1;
neighbouring_ie_msg_struct.network_beacon_period = 4;
neighbouring_ie_msg_struct.cluster_beacon_period = 4;
neighbouring_ie_msg_struct.Long_RD_id = 32;
neighbouring_ie_msg_struct.next_cluster_channel = 13;
neighbouring_ie_msg_struct.time_to_next_v = 32;
neighbouring_ie_msg_struct.rsi2_v = 8;
neighbouring_ie_msg_struct.snr_v = 8;
neighbouring_ie_msg_struct.mu_v = 3;
neighbouring_ie_msg_struct.beta_v = 4;

reserved_bin = fliplr(de2bi(double(0),1));
ID_bin = fliplr(de2bi(double(ID),neighbouring_ie_msg_struct.ID));
mu_i_bin = fliplr(de2bi(double(mu_i),neighbouring_ie_msg_struct.mu_i));
snr_i_bin = fliplr(de2bi(double(snr_i),neighbouring_ie_msg_struct.snr_i));
rssi2_i_bin = fliplr(de2bi(double(rssi2_i),neighbouring_ie_msg_struct.rssi2_i));
power_const_bin = fliplr(de2bi(double(power_const),neighbouring_ie_msg_struct.power_const));
next_channel_i_bin = fliplr(de2bi(double(next_channel_i),neighbouring_ie_msg_struct.next_channel_i));
time_to_next_i_bin = fliplr(de2bi(double(time_to_next_i),neighbouring_ie_msg_struct.time_to_next_i));
network_beacon_period_bin = fliplr(de2bi(double(network_beacon_period),neighbouring_ie_msg_struct.network_beacon_period));
cluster_beacon_period_bin = fliplr(de2bi(double(cluster_beacon_period),neighbouring_ie_msg_struct.cluster_beacon_period));
Long_RD_id_bin = fliplr(de2bi(double(Long_RD_id),neighbouring_ie_msg_struct.Long_RD_id));

msg_bin = [reserved_bin ID_bin mu_i_bin snr_i_bin rssi2_i_bin power_const_bin...
    next_channel_i_bin time_to_next_i_bin ...
    network_beacon_period_bin cluster_beacon_period_bin Long_RD_id_bin];

if next_channel_i == 1
    reserved_bin = fliplr(de2bi(double(0),3));
    next_cluster_channel_bin = fliplr(de2bi(double(next_cluster_channel),neighbouring_ie_msg_struct.next_cluster_channel));
    msg_bin = [msg_bin reserved_bin next_cluster_channel_bin];
end

if time_to_next_i == 1
    time_to_next_i_bin = fliplr(de2bi(double(time_to_next_v),neighbouring_ie_msg_struct.time_to_next_v));
    msg_bin = [msg_bin time_to_next_i_bin];
end

if rssi2_i == 1
    rsi2_v_bin = fliplr(de2bi(double(rsi2_v),neighbouring_ie_msg_struct.rsi2_v));
    msg_bin = [msg_bin rsi2_v_bin];
end

if snr_i == 1
    snr_v_bin = fliplr(de2bi(double(snr_v),neighbouring_ie_msg_struct.snr_v));
    msg_bin = [msg_bin snr_v_bin];
end

if mu_i == 1
    mu_v_bin = fliplr(de2bi(double(mu_v),neighbouring_ie_msg_struct.mu_v));
    beta_v_bin = fliplr(de2bi(double(beta_v),neighbouring_ie_msg_struct.beta_v));
    reserved_bin = fliplr(de2bi(double(0),1));
    msg_bin = [msg_bin mu_v_bin beta_v_bin reserved_bin];
end

% Header type d)
ie_type = [0 1 0 1 0 1]; % neighbouring ie message type 
len = length(msg_bin);
mac_mux_pdu = mac_mux_header_d_constr(ie_type, len);

msg_bin = [mac_mux_pdu msg_bin];

end 