%
% coding of feedback info format 1 as in 6.2.2-2a
% 

% Kalle Ruttik
% 23.11.2023

function [feedback_info_format1_struct] = coding_of_feedback_info_format1_parser(rx_msg_sdu)

% feedback_format_len = 4;
% HARQ_process_number_len = 3;
% transmission_feedback_len = 1;
% buffer_status_len = 4;
% cqi_len = 4;

%% binary generation
loc = 0;
feedback_info_format1_struct.feedback_format = bi2de(fliplr(rx_msg_sdu([1:4])));
feedback_info_format1_struct.HARQ_process_number = bi2de(fliplr(rx_msg_sdu([5:7])));
feedback_info_format1_struct.transmission_feedback = rx_msg_sdu(8);  loc = loc + 8;

feedback_info_format1_struct.buffer_status = bi2de(fliplr(rx_msg_sdu(loc+[1:4]))); 
feedback_info_format1_struct.cqi = bi2de(fliplr(rx_msg_sdu(loc+[5:8]))); loc = loc +8; 

end
