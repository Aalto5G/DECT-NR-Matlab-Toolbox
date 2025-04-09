%
% parsing received bit stream into SDUs
%

% Kalle Ruttik
% 29.10.2023

function [sdu_struct] = mac_SDUs_extraction(rx_sdus)

sdu_struct = {};

% parse the packet into sdu
len_sdus = length(rx_sdus);
len = 0;
while len < len_sdus
  mac_ext = bi2de(fliplr(rx_sdus(len+[1:2])));
  m = length(sdu_struct); 
  switch(mac_ext)
    case 0
     ie_type = bi2de(fliplr(rx_sdus(len+[3:8])));

     % the length has to be extracted from the type of the packet 
    
    case 1 
      ie_len = bi2de(fliplr(rx_sdus(len+[9:16])));
      ie_type = bi2de(fliplr(rx_sdus(len+[3:8]))); 
      ie_sdu = rx_sdus(len+16 +[1:ie_len]);
      len = len + 16+ie_len;
      sdu_struct{m+1} = {{1,ie_type,ie_len,ie_sdu}};
    case 2
      ie_len = bi2de(fliplr(rx_sdus(len+[9:24]))); 
      ie_type = bi2de(fliplr(rx_sdus(len+[3:8])));
      ie_sdu = rx_sdus(len+24 +[1:ie_len]);
      len = len + 24+ie_len;
      sdu_struct{m+1} = {{1,ie_type,ie_len,ie_sdu}};
    case 3
      payload_size = rx_sdus(len+3)
      ie_type = bi2de(fliplr(rx_sdus(len+[4:8]))); 
      
      if payload_size == 0
        ie_len = 0;
        ie_sdu = 0;
        sdu_struct{m+1} = {{2,ie_type,ie_len,ie_sdu}};
        len = len + 8;
      else
        ie_len = 8;
        ie_sdu = rx_sdus(len+8 +[1:ie_len])
        sdu_struct{m+1} = {{3,ie_type,ie_len,ie_sdu}};
        len = len + 16;
      end

  end
%  [mac_ext len len_sdus]
  
end
 
end