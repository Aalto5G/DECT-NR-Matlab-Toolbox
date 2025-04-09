%
% Generates sync as defined in 
% 
% synchronization training field
% ETSI TS 103 636-3 v1.4.1  section 5.1

% Kalle Ruttik
% 3.8.2023

% clear all 
% close all

% config 

% % transmission packet length in OFDM symbols
% packetLength = 1;
% packetLengthType = 0;
% if packetLengthType == 0
%   Npacketsymb = packetlength * NSlotmusymb/SSlotmusubslot;
% elseif packetLengthType == 1
%   Npacketsymb = packetlength * NSlotmusymb;
% end

function [stf] = dectSyncTrainingField(mu_beta)
% (phy_Control_Field,mu_beta)
% 
% if phy_Control_Field.Packet_Length_Type == 0
%   N_PACKET_symb = phy_Control_Field.phy_Packet_Length*mu_beta.N_SLOTmu_symb/mu_beta.N_SLOTmu_subslot;
% else 
%   if phy_Control_Field.Packet_Length_Type == 1
%     N_PACKET_symb = phy_Control_Field.phy_Packet_Length*mu_beta.N_SLOTmu_symb;
%   end
% end

mu = mu_beta.mu;
beta = mu_beta.beta;
N_DFT = mu_beta.N_DFT;
N_cp = mu_beta.N_cp;
T_mu_symb = (N_DFT  + N_cp);
if mu==1
  stfLen = 14/9*T_mu_symb;       % 7*16
  repVal = 7;
  GI = 4/9*T_mu_symb;
else 
  if (mu == 2 || mu == 4)
    stfLen = 2*T_mu_symb;        % 9*16
    repVal = 9;
    GI = 1*T_mu_symb;
  else 
    if (mu == 8)
     stfLen = 2*T_mu_symb;       % 9*16
     repVal = 9;
     GI = 2*T_mu_symb;
    end
  end
end

%% alternnating masking sequence from the presentation 9.11.23
% spec version 1.5.1
% 3.04.2024: Was in the presentation but did not found in the spec
c7 = [1 -1 1 1 -1 -1 -1]; % mu = 1
% c7 = [1 1 1 1 1 1 1];
c9 = [1 -1 1 1 1 -1 -1 -1 -1]; % mu = 2,4,8
% c9 = [1 1 1 1 1 1 1 1 1];

%% sync signal generation
% 5.2.2
STFm0B1 = [1 -1 1 1 -1 1 1 -1 1 1 1 -1 -1 -1]; % sequence S
y01 = exp(1i*pi/4)*STFm0B1; 
%y0beta(k) = (-1)k * y0beta(N-k)
%y0_2_r = (-1).^(1:length(STFm0B1)).*exp(1i*pi/4).*(fliplr(STFm0B1));

% beta = 2
STFm0B2 = [-1,1, -1,1,1, -1,1,1, -1,1,1,1, -1,1, -1, -1, -1,1, -1, -1, -1,1,1,1, -1, -1, -1, -1];
y02 = exp(1i*pi/4)*STFm0B2;
% beta = 4
STFm0B4 = [-1, -1, -1, 1, -1, 1, -1, -1, 1, 1, 1, 1, -1, 1, -1, -1, -1, 1, -1, 1, 1, -1, -1, -1, -1, -1, 1, -1, 1, 1, 1, -1, 1, -1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, 1, 1, -1, -1, -1, -1, -1, 1, -1];
y04 = exp(1i*pi/4)*STFm0B4;
y04r = (-1.^(1:length(y04))).*y04(length(y04)-(0:(length(y04)-1))); 
% beta = 8
% STFm0B8 = [STFm0B4,STFm0B4r];
y08 = [y04 y04r];
y08r = (-1.^(1:length(y08))).*y08(length(y08)-(0:(length(y08)-1))); 
% beta = 16
% STFm0B16 = [STFm0B8,STFm0B8r];
y016 = [y08 y08r];

% beta = 12
% STFm0B12 = [STFm0B16*[0:(12*14-1)]+2*14];
y012 = y016((0:(12*14-1))+2*14+1);

switch beta
  case 1
    yr = [0 y01(1:7) 0 y01(8:14)];
  case 2
    yr = [0 y02(1:(2*7)) 0 y02((2*7+1):(2*14))];
  case 4
    yr = [0 y04(1:(4*7)) 0 y04((4*7+1):(4*14))];
  case 8
    yr = [0 y08(1:(8*7)) 0 y08((8*7+1):(8*14))];   
  case 16
    yr = [0 y016(1:(16*7)) 0 y016((16*7+1):(16*14))];   
  case 12
    yr = [0 y012(1:(12*7)) 0 y012((12*7+1):(12*14))];      
  otherwise 

  yr = [];
end

%% 
%% generate synchronization training field STF as in 5.2.2
% 
if repVal == 7
  w1 = repmat(c7,16,1);
else
  w1 = repmat(c9,16,1);
end

w1 = w1(:)';

if isempty(yr)
  syncTrainingField = [];  
else 
  syncSignalT = ifft(fftshift(yr));
  syncTrainingField = repmat(syncSignalT,1,repVal);

  %stf = syncTrainingField;
end

%% multiplication for 1.5.1 case 
syncTrainingField = syncTrainingField.*w1;
stf = syncTrainingField;
% mapping to each forth sample (ie downsampled by 4) 64/4 = 16
% repetition of the generated sequence in time 
% 7 times seq = 7*16 = 112

% demo for the the correlation
% plot(abs(xcorr((syncTrainingField),syncTrainingField)))

end
