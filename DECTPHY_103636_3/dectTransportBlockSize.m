%
% Transport Block Size (TBS) computation 
%
% 103636-3 5.3
% 

% Kalle Ruttik
% 10.8.2023

function [N_TB_bits] = dectTransportBlockSize(N_PDC_re,phy_Control_Field,transmission_modes,mu_beta)

% N_PDC_re = length(ind_pdc);
N_ss = transmission_modes.N_ss;

MCS = phy_Control_Field.DF_MCS;
[modulation,N_bps,R] = dectMCSTable(MCS);

N_PDC_bits = floor(N_ss*N_PDC_re*N_bps*R);

L = 24;
Z = 2048; % or Z = 6144;

if (N_PDC_bits<=512)
    M= 8;
elseif (N_PDC_bits<=1024)
    M = 16;
elseif (N_PDC_bits<=2048)
    M = 32;
else
    M = 64;
end

N_M = floor(N_PDC_bits/M)*M;

if N_M <= Z
N_TB_bits = N_M - L;
C = 1;

else
C = ceil((N_M -L)/Z); % number of code blocks

N_TB_bits = N_M - (C+1)*L; % amount of input bits 
end

end