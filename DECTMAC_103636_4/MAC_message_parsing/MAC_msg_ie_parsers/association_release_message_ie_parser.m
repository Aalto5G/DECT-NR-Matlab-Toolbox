%
% association release message parser
%

% Kalle Ruttik
% 30.10.2023

function [ association_release_message_ie_struct] = association_release_message_ie_parser(rx_msg_sdu,ie_len)

release_cause_len = 4;

association_release_message_ie_struct.release_cause = bi2de(fliplr(rx_msg_sdu([1:4]))); 

end