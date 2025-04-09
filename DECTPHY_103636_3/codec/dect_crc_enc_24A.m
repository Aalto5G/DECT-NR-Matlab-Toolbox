% Computes CRC as in LTE 24A
%

function [out_bits] = dect_crc_enc_24A(in_bits)
  
 % 24A
 crc_polynome = [1,1,0,0,0,0,1,1,0,0,1,0,0,1,1,0,0,1,1,1,1,1,0,1,1];
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
