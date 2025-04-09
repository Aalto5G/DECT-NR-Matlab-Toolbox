%
% Computes the code block structure
%

% Kalle Ruttik
% 30.10.2024

function [codeStruct] = LTE_SegmentStruct(blklen)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code block segmentation
% 103.363-3 v1.5.1 section 6.1.3
Z = 6144; % 6144 is in LTE
% Z = 2048;

B = blklen + 24;
% B = length(dataIn_crc);
% if B < 40
%   C = 1;
%   L = 0;
%   Bprim = 40;
%   tmp = -1*ones(1,40);
%   tmp((end-length(dataIn)+1):end) =dataIn;
%   dataIn = tmp;
%
% else
  if B <= Z
    L = 0;
    C = 1;
    Bprim = B;
  else
    L = 24;
    C = ceil(B/(Z-L));
    Bprim = B +C*L;
  end
% end

%%
% find for Kplus
% first segmenetation in size Kplus = min(K such that C*K>=Bprim)

% gives out Kvalues
InterleaverValuesinLTESpec

% finds Kplus
%[v,l]=max(Kvalues(:,2)>=min(Bprim/C));
[v,loc]=max(Kvalues(:,2)*C>=Bprim);
Kplus = Kvalues(loc,2);

if C == 1
  Kplus = Kplus;
  Cplus = 1;
  Kmin = 0;
  Cmin = 0;
  % elseif
else if C >= 1
%     [v,l] = max( Kvalues(:,2)>= Kplus);
    Kmin = Kvalues(loc-1,2);
    dK = Kplus - Kmin;
    Cmin = floor((C*Kplus - Bprim)/dK);
    Cplus = C - Cmin;
 end
end


%% number of filler bits
% for dect has to be zero since MAC pdu is max size with filler bits at the end
F = Cplus*Kplus + Cmin*Kmin -Bprim;

% C Cplus Cmin Kplus Kmin F
codeStruct.C = C;
codeStruct.Cplus = Cplus;
codeStruct.Cmin = Cmin;
codeStruct.Kplus = Kplus;
codeStruct.Kmin = Kmin;
codeStruct.F = F;
codeStruct.L = L;
codeStruct.Bprim = Bprim;

end
