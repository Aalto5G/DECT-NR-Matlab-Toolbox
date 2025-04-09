%
% how many bits are in packet give 
% amount of carriers 
% N_ss 
% N_bps
% rate 
% 

function [N_TB_bits] = bitLenEval(N_PDC_re, N_SS, N_bps, R)
%% 
% Transport block size computation
%N_PDC_re = 56; % length(ind_pdc); % number of carriers

%N_SS = 1;                   % layers 
%N_bps = 2;                  % bits per symbol
%R = 1/2;                    % code rate

N_PDC_bits = floor(N_SS*N_PDC_re*N_bps*R);  % bits on radio interface (output)

Z = 2048;

L = 24; % crc size 

if (N_PDC_bits<512)
    M= 8;
elseif (N_PDC_bits<1024)
    M = 16;
elseif (N_PDC_bits<2048)
    M = 32;
else
    M = 64;
end

N_m = floor(N_PDC_bits/M)*M;

if N_m < Z
  C = 1;
  N_TB_bits = N_m - L;
else 
  C = ceil((N_m -L)/Z); % number of code blocks

  N_TB_bits = N_m - (C+1)*L; % amount of input bits 
end

% N_TB_bits - size of the MAC data packet

end 