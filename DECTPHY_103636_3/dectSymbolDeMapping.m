%
% estimate soft symbols from the received IQ samples 
%

% Kalle Ruttik
% 11.8.2023

function [soft_symbols] = dectSymbolDeMapping(pcc_re_symbols,MCS)

switch MCS

  case 0
    %soft_symbols = real(pcc_re_symbols*(exp(-1i*pi/4)));
    soft_symbols = real(pcc_re_symbols);

  case {1,2}
    soft_symbols = zeros(length(pcc_re_symbols)*2,1);
    soft_symbols(1:2:end) = real(pcc_re_symbols); % *(exp(-1i*pi/4));
    soft_symbols(2:2:end) = imag(pcc_re_symbols); % *(exp(-1i*pi/4));
%    soft_symbols(1:2:end) = real(pcc_re_symbols*(exp(-1i*pi/4)));
%    soft_symbols(2:2:end) = imag(pcc_re_symbols*(exp(-1i*pi/4)));
  
  case {3:11}
     printf('Not supported yet\n')
  otherwise
    soft_symbols = [];

end 
end