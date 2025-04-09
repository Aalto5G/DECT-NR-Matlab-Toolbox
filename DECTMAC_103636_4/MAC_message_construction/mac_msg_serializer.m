%
% Creates from a binary elements vector a uint8 type serialized data
% the output could be sent over UDP
%

% Kalle Ruttik
% 8.02.2024

function [mac_msg_bin] = mac_msg_serializer(rx_mac_sdus)

len8 = length(rx_mac_sdus)/8;
mac_msg_bin = uint8(bi2de(fliplr((reshape(rx_mac_sdus,8,len8)'))))';

end