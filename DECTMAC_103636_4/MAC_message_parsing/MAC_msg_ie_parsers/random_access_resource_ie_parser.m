%
% random access resource ie parser 
%

% Kalle Ruttik 
% 30.10.2023

function [random_access_resource_ie_struct] = random_access_resource_ie_parser(rx_msg_sdu,ie_len)

loc = 0; 
random_access_resource_ie_struct.Repeat = bi2de(fliplr(rx_msg_sdu([4:5]))); 
random_access_resource_ie_struct.SFN = bi2de(fliplr(rx_msg_sdu([6]))); 
random_access_resource_ie_struct.Channel = bi2de(fliplr(rx_msg_sdu(7))); 
random_access_resource_ie_struct.Channel_2 = bi2de(fliplr(rx_msg_sdu(8))); loc = loc + 8;

random_access_resource_ie_struct.Start_subslot = bi2de(fliplr(rx_msg_sdu(loc +[1:8]))); loc = loc + 8;

random_access_resource_ie_struct.Length_type = bi2de(fliplr(rx_msg_sdu(loc +1)));
random_access_resource_ie_struct.Length = bi2de(fliplr(rx_msg_sdu(loc +[2:8]))); loc = loc + 8;

random_access_resource_ie_struct.MAX_len_type = bi2de(fliplr(rx_msg_sdu(loc +1)));
random_access_resource_ie_struct.MAX_RACH_length = bi2de(fliplr(rx_msg_sdu(loc +[2:5])));
random_access_resource_ie_struct.CW_min_sig = bi2de(fliplr(rx_msg_sdu(loc +[6:8]))); loc = loc + 8;

random_access_resource_ie_struct.DECT_delay = bi2de(fliplr(rx_msg_sdu(loc +1)));
random_access_resource_ie_struct.response_window = bi2de(fliplr(rx_msg_sdu(loc +[2:5])));
random_access_resource_ie_struct.CW_max_sig = bi2de(fliplr(rx_msg_sdu(loc +[6:8]))); loc = loc + 8;

if random_access_resource_ie_struct.Repeat>0
  random_access_resource_ie_struct.repetition = bi2de(fliplr(rx_msg_sdu(loc +[1:8])));loc = loc + 8;

  random_access_resource_ie_struct.validity = bi2de(fliplr(rx_msg_sdu(loc +[1:8]))); loc = loc + 8;
end

if random_access_resource_ie_struct.SFN == 1
  random_access_resource_ie_struct.SFN_offset = bi2de(fliplr(rx_msg_sdu(loc +[1:8]))); loc = loc + 8;
end

if random_access_resource_ie_struct.Channel == 1
random_access_resource_ie_struct.Channel1 = bi2de(fliplr(rx_msg_sdu(loc +[4:16]))); loc = loc + 16;
end

if random_access_resource_ie_struct.Channel_2 == 1
  random_access_resource_ie_struct.Channel2 = bi2de(fliplr(rx_msg_sdu(loc +[4:16])));
end
end 