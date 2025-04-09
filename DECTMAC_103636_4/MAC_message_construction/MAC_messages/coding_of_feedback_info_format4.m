%
% coding of feedback info as in 6.2.2-2a
% 

% Kalle Ruttik
% 23.11.2023

function [feedback_info_bin] = coding_of_feedback_info_format4(feedback_format,HARQ_feedback_bitmap, cqi)

feedback_format_len = 4;
HARQ_feedback_bitmap_len = 8;
cqi_len = 4;

%% binary generation
feedback_format_bin = fliplr(de2bi(double(feedback_format),feedback_format_len));
HARQ_feedback_bitmap_bin =  fliplr(de2bi(double(HARQ_feedback_bitmap),HARQ_feedback_bitmap_len));
cqi_bin =  fliplr(de2bi(double(cqi),cqi_len));

feedback_info_bin = [feedback_format_bin HARQ_feedback_bitmap_bin cqi_bin];

end