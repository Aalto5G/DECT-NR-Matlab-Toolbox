%
% coding of feedback info format 1 as in 6.2.2-2a
% 

% Kalle Ruttik
% 23.11.2023

function [feedback_info_format3_struct] = coding_of_feedback_info_format3_parser(rx_msg_sdu)

feedback_format_len = 4;
HARQ_process_number_len = 3;
transmission_feedback_len = 1;
HARQ_process_number2_len = 3;
transmission_feedback2_len = 1;
cqi_len = 4;

%% binary generation
loc = 0;
feedback_info_format3_struct.feedback_format = bi2de(fliplr(rx_msg_sdu([1:4])));
feedback_info_format3_struct.HARQ_process_number = bi2de(fliplr(rx_msg_sdu([5:7])));
feedback_info_format3_struct.transmission_feedback = rx_msg_sdu(8);  loc = loc + 8;

feedback_info_format3_struct.HARQ_process_number = bi2de(fliplr(rx_msg_sdu(loc + [1:3])));
feedback_info_format3_struct.transmission_feedback = rx_msg_sdu(loc + 4);
feedback_info_format3_struct.cqi = bi2de(fliplr(rx_msg_sdu(loc+[5:8]))); loc = loc +8; 

end
