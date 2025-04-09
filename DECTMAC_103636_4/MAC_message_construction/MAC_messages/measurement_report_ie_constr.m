%
% measurement report ie constrcution
%

% Kalle Ruttik
% 10.05.2024

function [msg_bin] = measurement_report_ie_constr(reserved, ...
    SNR, RSSI_2, RSSI_1, Txcount, rach, SNRresult, RSSI_2_result, RSS2_1_result, Txcountresult)


measurement_report_ie.reserved_len = 3;
measurement_report_ie.SNR_len = 1;
measurement_report_ie.RSSI_2_len = 1;
measurement_report_ie.RSSI_1_len = 1;
measurement_report_ie.Txcount_len = 1;
measurement_report_ie.RACH_len = 1;
measurement_report_ie.SNR_result_len = 8;
measurement_report_ie.RSSI_2_result_len = 8;
measurement_report_ie.RSSI_1_result_len = 8;
measurement_report_ie.Txcountresult_len = 8;

reserved_bin = fliplr(de2bi(double(reserved),measurement_report_ie.reserved_len));
SNR_bin = fliplr(de2bi(double(SNR),measurement_report_ie.SNR_len));
RSSI_2_bin = fliplr(de2bi(double(RSSI_2),measurement_report_ie.RSSI_2_len));
RSSI_1_bin = fliplr(de2bi(double(RSSI_1),measurement_report_ie.RSSI_1_len));
Txcount_bin = fliplr(de2bi(double(Txcount),measurement_report_ie.Txcount_len));
RACH_bin = fliplr(de2bi(double(rach),measurement_report_ie.RACH_len));

msg_bin = [reserved_bin SNR_bin RSSI_2_bin RSSI_1_bin Txcount_bin RACH_bin];

if SNR == 1
  SNRresult_bin =  fliplr(de2bi(double(SNRresult),measurement_report_ie.SNR_result_len));
  msg_bin = [msg_bin SNRresult_bin];
end

if RSSI_2 == 1
  RSSI_2_result_bin =  fliplr(de2bi(double(RSSI_2_result),measurement_report_ie.RSSI_2_result_len));
  msg_bin = [msg_bin RSSI_2_result_bin];
end

if RSSI_1 == 1
  RSSI_1_result_bin =  fliplr(de2bi(double(RSS2_1_result),measurement_report_ie.RSSI_1_result_len));
  msg_bin = [msg_bin RSSI_1_result_bin];
end

if Txcount == 1
  Txcountresult_bin =  fliplr(de2bi(double(Txcountresult),measurement_report_ie.Txcountresult_len));
  msg_bin = [msg_bin Txcountresult_bin];
end

% ie type defines the length of the ie payload
% type c) without length indication
ie_type = [0 1 1 0 0 1];
mac_extension_field_encoding = [0 1];
mac_mux_pdu = [mac_extension_field_encoding ie_type];

% Header type d)
% ie_type = [0 1 0 1 0 1]; % neighbouring ie message type 
% len = length(msg_bin);
% mac_mux_pdu = mac_mux_header_d_constr(ie_type, len);

% adding the header to the binary data
len = length(msg_bin);
len_bin = fliplr(de2bi(len,8));
msg_bin = [mac_mux_pdu len_bin msg_bin];

end
