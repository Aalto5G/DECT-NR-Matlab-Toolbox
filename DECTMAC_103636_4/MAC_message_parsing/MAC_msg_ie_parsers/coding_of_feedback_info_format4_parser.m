%
% coding of feedback info format 1 as in 6.2.2-2a
% 

% Kalle Ruttik
% 23.11.2023

function [feedback_info_format4_struct] = coding_of_feedback_info_format4_parser(rx_msg_sdu)

% feedback_format_len = 4;
% HARQ_feedback_bitmap_len = 8;
% cqi_len = 4;

%% binary generation
loc = 0;
feedback_info_format4_struct.feedback_format = bi2de(fliplr(rx_msg_sdu([1:4])));
feedback_info_format4_struct.HARQ_process_number = bi2de(fliplr(rx_msg_sdu([5:12]))); loc = loc + 8;
feedback_info_format4_struct.cqi = bi2de(fliplr(rx_msg_sdu(loc+[5:8]))); loc = loc +8; 

end
