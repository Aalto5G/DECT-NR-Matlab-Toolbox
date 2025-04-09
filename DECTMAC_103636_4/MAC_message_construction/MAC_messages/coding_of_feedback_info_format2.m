%
% coding of feedback info as in 6.2.2-2a
% 

% Kalle Ruttik
% 23.11.2023

function [feedback_info_bin] = coding_of_feedback_info_format2(feedback_format,Codebook_index,MIMO_Feedback, buffer_status, cqi)

feedback_format_len = 4;
Codebook_index_len = 3;
MIMO_Feedback_len = 1;
buffer_status_len = 4;
cqi_len = 4;


%% binary generation
feedback_format_bin = fliplr(de2bi(double(feedback_format),feedback_format_len));
Codebook_index_bin =  fliplr(de2bi(double(Codebook_index),Codebook_index_len));
MIMO_Feedback_bin =  fliplr(de2bi(double(MIMO_Feedback),MIMO_Feedback_len));
buffer_status_bin =  fliplr(de2bi(double(buffer_status),buffer_status_len));
cqi_bin =  fliplr(de2bi(double(cqi),cqi_len));

feedback_info_bin = [feedback_format_bin Codebook_index_bin MIMO_Feedback_bin buffer_status_bin cqi_bin];

end