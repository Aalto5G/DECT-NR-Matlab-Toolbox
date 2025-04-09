% Computes CRC as in LTE 
% the type is selected by crc_type 
% 24A
% 24B

function [out_bits] = LTE_CRCEncode(in_bits,crc_type)

 if (crc_type == '24A')
   crc_polynome = [1,1,0,0,0,0,1,1,0,0,1,0,0,1,1,0,0,1,1,1,1,1,0,1,1];
 elseif (crc_type == '24B')
   crc_polynome = [1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,1];
 else
  printf("unknown CRC type \n");
  out_bits = in_bits;
  return
 end 
% 24B

 crc_len  = length(crc_polynome)-1; % should be 24;

  shift_register   = zeros(1,crc_len+1);
  bits_and_crc = [in_bits, zeros(1,crc_len)];

  % Loop to calculate CRC bits
  for i1=1:(length(in_bits)+crc_len)
    shift_register(1:crc_len) = shift_register(2:crc_len+1);
    shift_register(crc_len+1) = bits_and_crc(i1);

     if shift_register(1) ~=0
      shift_register = mod(shift_register+crc_polynome,2);  
     end
  end

  crc_bits = shift_register(2:end);
  out_bits = [in_bits crc_bits]';

end
