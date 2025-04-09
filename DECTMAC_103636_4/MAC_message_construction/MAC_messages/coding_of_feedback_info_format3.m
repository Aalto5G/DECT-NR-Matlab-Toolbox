%
% coding of feedback info as in 6.2.2-2a
% 

% Kalle Ruttik
% 23.11.2023

function [feedback_info_bin] = coding_of_feedback_info_format3(feedback_format,HARQ_process_number, transmission_feedback, HARQ_process_number2, transmission_feedback2, cqi)

feedback_format_len = 4;
HARQ_process_number_len = 3;
transmission_feedback_len = 1;
HARQ_process_number2_len = 3;
transmission_feedback2_len = 1;
cqi_len = 4;

%% binary generation
feedback_format_bin = fliplr(de2bi(double(feedback_format),feedback_format_len));
HARQ_process_number_bin =  fliplr(de2bi(double(HARQ_process_number),HARQ_process_number_len));
transmission_feedback_bin =  fliplr(de2bi(double(transmission_feedback),transmission_feedback_len));
HARQ_process_number2_bin =  fliplr(de2bi(double(HARQ_process_number2),HARQ_process_number2_len));
transmission_feedback2_bin =  fliplr(de2bi(double(transmission_feedback2),transmission_feedback2_len));
cqi_bin =  fliplr(de2bi(double(cqi),cqi_len));

feedback_info_bin = [feedback_format_bin HARQ_process_number_bin transmission_feedback_bin HARQ_process_number2_bin transmission_feedback2_bin cqi_bin];


end