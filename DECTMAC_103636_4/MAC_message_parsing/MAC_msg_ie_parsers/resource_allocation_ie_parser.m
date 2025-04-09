%
% resource allocation ie parser
%

% Kalle Ruttik
% 30.10.2023

function [resource_allocation_ie_struct] = resource_allocation_ie_parser(rx_msg_sdu,ie_len)

loc = 0;
resource_allocation_ie_struct.allocation_type = bi2de(fliplr(rx_msg_sdu([1:2]))); 
resource_allocation_ie_struct.add = rx_msg_sdu(3);
resource_allocation_ie_struct.id = rx_msg_sdu(4);
resource_allocation_ie_struct.repeat = bi2de(fliplr(rx_msg_sdu([5:7])));
resource_allocation_ie_struct.sfn = rx_msg_sdu(8); loc = loc + 8;


resource_allocation_ie_struct.Channel_1 = rx_msg_sdu(loc + 1);
resource_allocation_ie_struct.rlf = rx_msg_sdu(loc + 2); loc = loc + 8;
resource_allocation_ie_struct.start_subslot = bi2de(fliplr(rx_msg_sdu(loc + [1:8]))); loc = loc +8;

resource_allocation_ie_struct.length_type = rx_msg_sdu(loc + 1);
resource_allocation_ie_struct.length =  bi2de(fliplr(rx_msg_sdu(loc + [2:8]))); loc = loc + 8;

resource_allocation_ie_struct.start_subslot2 = bi2de(fliplr(rx_msg_sdu(loc + [1:8]))); loc = loc +8;

resource_allocation_ie_struct.length_type2 = rx_msg_sdu(loc + 1);
resource_allocation_ie_struct.length2 =  bi2de(fliplr(rx_msg_sdu(loc + [2:8]))); loc = loc + 8;

if id == 1
resource_allocation_ie_struct.short_rc_id =
end

if repeat > 0
resource_allocation_ie_struct.repetition =  bi2de(fliplr(rx_msg_sdu(loc + [1:8]))); loc = loc + 8;
resource_allocation_ie_struct.validity =   bi2de(fliplr(rx_msg_sdu(loc + [1:8]))); loc = loc + 8;
end

if sfn == 1
resource_allocation_ie_struct.sfn_offset =  bi2de(fliplr(rx_msg_sdu(loc + [1:8]))); loc = loc + 8;
end

if Chanenl_1 == 1
resource_allocation_ie_struct.channel1 = bi2de(fliplr(rx_msg_sdu(loc + [4:16]))); loc = loc + 16;
end

if rlf == 1
resource_allocation_ie_struct.dectScheduledResourceFailure = bi2de(fliplr(rx_msg_sdu(loc + [5:8])));
end

end