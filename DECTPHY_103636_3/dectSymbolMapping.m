%
% Symbol Mapping from BPSK -- 1024QAM
%

% Kalle Ruttik
% 7.8.2023

% 103636-3 6.3.1. 

function [symbols] = dectSymbolMapping(inputBits,MCS)

[modType,N_bps,R] = dectMCSTable(MCS);

%symbols = [];
%G = 1024*10*4;
%inputBits = randn(1,G)>0;

%modType = 'QPSK'

sqrt2 = sqrt(1/2);
switch modType
  case 'BPSK'
    x = sqrt2*((1-2*inputBits) + 1i*(1-2*inputBits));
  case 'QPSK'
    
    tmpBits = reshape(inputBits,2,length(inputBits)/2);
    x = sqrt2*([1 1i])*(1-2*tmpBits);

  case '16QAM'

    tmpBits = reshape(inputBits,4,length(inputBits)/4);
    tmpBitsM = 1-2*tmpBits;
    x = sqrt(1/10)*[1 1i]* [tmpBitsM(1,:).*(2-tmpBitsM(3,:));...
                           tmpBitsM(2,:).*(2-tmpBitsM(4,:))]

  case '64QAM'

    tmpBits = reshape(inputBits,6,length(inputBits)/6);
    tmpBitsM = 1-2*tmpBits;
    x = sqrt(1/42)*[1 1i]* [tmpBitsM(1,:).*(4-tmpBitsM(3,:).*(2-tmpBitsM(5,:)));...
                            tmpBitsM(2,:).*(4-tmpBitsM(4,:).*(2-tmpBitsM(6,:)))];

  case '256QAM'
    tmpBits = reshape(inputBits,8,length(inputBits)/8);
    tmpBitsM = 1-2*tmpBits;
    x = sqrt(1/170)*[1 1i]* [tmpBitsM(1,:).*(8-tmpBits(3,:).*(4-tmpBitsM(5,:).*(2-tmpBitsM(7,:))));...
                            tmpBitsM(2,:).*(8-tmpBits(4,:).*(4-tmpBitsM(6,:).*(2-tmpBitsM(8,:))))];

  case '1024QAM'
    tmpBits = reshape(inputBits,10,length(inputBits)/10);
    tmpBitsM = 1-2*tmpBits;
    x = sqrt(1/170)*[1 1i]* [tmpBitsM(1,:).*(16-tmpBitsM(3,:).*(8-tmpBits(5,:).*(4-tmpBitsM(7,:).*(2-tmpBitsM(9,:)))));...
                            tmpBitsM(2,:).*(16-tmpBitsM(4,:).*(8-tmpBits(6,:).*(4-tmpBitsM(8,:).*(2-tmpBitsM(10,:)))))];
  otherwise
    x = []
end

symbols = x;

end