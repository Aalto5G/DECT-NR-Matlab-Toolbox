%
% Gives parameters for dect MCS
%

% Kalle Ruttik
% 10.8.2023

function [modulation,N_bps,R] = dectMCSTable(MCS)

% Annex A. MCS schemes 
switch MCS
  case 0
    modulation = 'BPSK';
    N_bps = 1;
    R =1/2;
  case 1
    modulation = 'QPSK';
    N_bps = 2;
    R =1/2;
  case 2
    modulation = 'QPSK';
    N_bps = 2;
    R =3/4;
  case 3
    modulation = '16QAM';
    N_bps = 4;
    R =1/2;
  case 4
    modulation = '16QAM';
    N_bps = 4;
    R =3/4;
  case 5
    modulation = '64QAM';
    N_bps = 6;
    R =2/3;
  case 6
    modulation = '64QAM';
    N_bps = 6;
    R =3/4;
  case 7
    modulation = '64QAM';
    N_bps = 6;
    R =5/6;
  case 8
    modulation = '256QAM';
    N_bps = 8;
    R =3/4;
  case 9
    modulation = '256QAM';
    N_bps = 8;
    R =5/6;
  case 10
    modulation = '1024QAM';
    N_bps = 10;
    R =3/4;
  case 11
    modulation = '1024QAM';
    N_bps = 10;
    R =5/6;
  otherwise
    modulation = [];
    N_bps = [];
    R =[];
end

end
 
