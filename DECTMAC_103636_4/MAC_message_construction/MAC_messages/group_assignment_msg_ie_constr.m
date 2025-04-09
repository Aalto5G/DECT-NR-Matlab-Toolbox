%
% Group Assignment IE message construction
%

% Jaakko Niemistö
% 5.4.2024


function [msg_bin] = group_assignment_msg_ie_constr(...
    single,group_id,direct,resource_tag)

group_assignment_msg_struct.single = 1;
group_assignment_msg_struct.group_id = 7;
group_assignment_msg_struct.direct = 1; % array
group_assignment_msg_struct.resource_tag = 7; % array

single_bin = fliplr(de2bi(double(single),group_assignment_msg_struct.single));
group_id_bin = fliplr(de2bi(double(group_id),group_assignment_msg_struct.group_id));

msg_bin = [single_bin group_id_bin];

for i = 1:length(resource_tag)
    direct_bin = fliplr(de2bi(double(direct(i)),group_assignment_msg_struct.direct));
    resource_tag_bin = fliplr(de2bi(double(resource_tag(i)),group_assignment_msg_struct.resource_tag));
    msg_bin = [msg_bin direct_bin resource_tag_bin];
end

% Header type d)
ie_type = [0 1 0 1 1 1]; % group assignment ie message type 
len = length(msg_bin);
mac_mux_pdu = mac_mux_header_d_constr(ie_type, len);

msg_bin = [mac_mux_pdu msg_bin];

end 