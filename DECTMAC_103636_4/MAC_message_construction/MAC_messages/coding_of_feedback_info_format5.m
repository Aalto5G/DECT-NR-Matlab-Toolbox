%
% coding of feedback info as in 6.2.2-2a
% 

% Kalle Ruttik
% 23.11.2023

function [feedback_info_bin] = coding_of_feedback_info_format5(feedback_format,HARQ_process_number, transmission_feedback, MIMO_feedback, Codebook_index)

feedback_format_len = 4;
HARQ_process_number_len = 3;
transmission_feedback_len = 1;
MIMO_feedback_len = 2;
Codebook_index_len = 6;

feedback_format_bin = fliplr(de2bi(double(feedback_format),feedback_format_len));
HARQ_process_number_bin =  fliplr(de2bi(double(HARQ_process_number),HARQ_process_number_len));
transmission_feedback_bin =  fliplr(de2bi(double(transmission_feedback),transmission_feedback_len));
MIMO_feedback_bin =  fliplr(de2bi(double(MIMO_feedback),MIMO_feedback_len));
Codebook_index_bin =  fliplr(de2bi(double(Codebook_index),Codebook_index_len));

feedback_info_bin = [feedback_format_bin HARQ_process_number_bin transmission_feedback_bin HARQ_feedback_bin Codebook_index_bin];

end