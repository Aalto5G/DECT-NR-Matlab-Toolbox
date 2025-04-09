% 
% extracts from the 
% take actions based on parsing result 
%

function [rx_sdu] = mac_RxProcessing(rx_mac_bits)


% select actions based on structure 
switch(MAC_header_type.MAC_header_type)
  case 0:
    % DATA MAC PDU header as defined in Figure 6.3.3.1-1
    break
  case 1:
    % Beacon Header as defined in Figure 6.3.3.2-1
    break:
  case 2:
    % Unicast Header as defined in Figure 6.3.3.3-1
    break
  case 3:
    % RD Broadcasting Header as defined in Figure 6.3.3.4-1
    break
  case 15
    % Escape
    break
end

end