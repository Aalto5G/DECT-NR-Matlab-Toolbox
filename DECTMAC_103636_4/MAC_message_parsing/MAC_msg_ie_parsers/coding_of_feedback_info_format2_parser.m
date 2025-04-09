%
% coding of feedback info format 2 as in 6.2.2-2a
% 

% Kalle Ruttik
% 23.11.2023

function [feedback_info_format2_struct] = coding_of_feedback_info_format2_parser(rx_msg_sdu)

% feedback_format_len = 4;
% Codebook_index_len = 3;
% MIMO_Feedback_len = 1;
% buffer_status_len = 4;
% cqi_len = 4;

%% binary generation
loc = 0;
feedback_info_format2_struct.feedback_format = bi2de(fliplr(rx_msg_sdu([1:4])));
feedback_info_format2_struct.Codebook_index = bi2de(fliplr(rx_msg_sdu([5:7])));
feedback_info_format2_struct.MIMO_Feedback = rx_msg_sdu(8);  loc = loc + 8;

feedback_info_format2_struct.buffer_status = bi2de(fliplr(rx_msg_sdu(loc+[1:4]))); 
feedback_info_format2_struct.cqi = bi2de(fliplr(rx_msg_sdu(loc+[5:8]))); loc = loc +8; 

end
