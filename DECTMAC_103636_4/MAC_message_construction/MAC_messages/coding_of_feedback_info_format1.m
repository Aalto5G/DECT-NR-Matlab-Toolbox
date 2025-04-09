%
% coding of feedback info as in 6.2.2-2a
% 

% Kalle Ruttik
% 23.11.2023

function [feedback_info_bin] = coding_of_feedback_info_format1(feedback_format,HARQ_process_number, transmission_feedback, buffer_status, cqi)

feedback_format_len = 4;
HARQ_process_number_len = 3;
transmission_feedback_len = 1;
buffer_status_len = 4;
cqi_len = 4;

%% binary generation
feedback_format_bin = fliplr(de2bi(double(feedback_format),feedback_format_len));
HARQ_process_number_bin =  fliplr(de2bi(double(HARQ_process_number),HARQ_process_number_len));
transmission_feedback_bin =  fliplr(de2bi(double(transmission_feedback),transmission_feedback_len));
buffer_status_bin =  fliplr(de2bi(double(buffer_status),buffer_status_len));
cqi_bin =  fliplr(de2bi(double(cqi),cqi_len));

feedback_info_bin = [feedback_format_bin HARQ_process_number_bin transmission_feedback_bin buffer_status_bin cqi_bin];

end
