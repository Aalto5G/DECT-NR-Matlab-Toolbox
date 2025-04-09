% dataIn = randn(1,7992)<0;%0:7999;



function [cbs,codeStruct] = LTE_CodeBlockSegment(dataIn_crc)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code block segmentation
% 103.363-3 v1.5.1 section 6.1.3
Z = 6144; % 6144 is in LTE
% Z = 2048;
% 
% B = length(dataIn_crc);
% % if B < 40
% %   C = 1;
% %   L = 0;
% %   Bprim = 40;
% %   tmp = -1*ones(1,40);
% %   tmp((end-length(dataIn)+1):end) =dataIn;
% %   dataIn = tmp;
% %
% % else
%   if B <= Z
%     L = 0;
%     C = 1;
%     Bprim = B;
%   else
%     L = 24;
%     C = ceil(B/(Z-L));
%     Bprim = B +C*L;
%   end
% % end
% 
% %%
% % find for Kplus
% % first segmenetation in size Kplus = min(K such that C*K>=Bprim)
% 
% % gives out Kvalues
% InterleaverValuesinLTESpec
% 
% % finds Kplus
% %[v,l]=max(Kvalues(:,2)>=min(Bprim/C));
% [v,loc]=max(Kvalues(:,2)*C>=Bprim);
% Kplus = Kvalues(loc,2);
% 
% if C == 1
%   Kplus = Kplus;
%   Cplus = 1;
%   Kmin = 0;
%   Cmin = 0;
%   % elseif
% else if C >= 1
% %     [v,l] = max( Kvalues(:,2)>= Kplus);
%     Kmin = Kvalues(loc-1,2);
%     dK = Kplus - Kmin;
%     Cmin = floor((C*Kplus - Bprim)/dK);
%     Cplus = C - Cmin;
%  end
% end
% 
% 
% %% number of filler bits
% % for dect has to be zero since MAC pdu is max size with filler bits at the end
% F = Cplus*Kplus + Cmin*Kmin -Bprim;


B = length(dataIn_crc)-24; % B is length without crc 
cStruct = LTE_SegmentStruct(B);

% encoded blocks
% minLen = (cStruct.Kmin+4)*3
% maxlen = (cStruct.Kplus+4)*3
% punctured block sizes 
C = cStruct.C;
Cmin = cStruct.Cmin;
Cplus = cStruct.Cplus;
Kmin = cStruct.Kmin;
Kplus = cStruct.Kplus;
F = cStruct.F;
L = cStruct.L;
Bprim = cStruct.Bprim;

% C Cplus Cmin Kplus Kmin F
codeStruct.C = C;
codeStruct.Cplus = Cplus;
codeStruct.Cmin = Cmin;
codeStruct.Kplus = Kplus;
codeStruct.Kmin = Kmin;
codeStruct.F = F;
codeStruct.L = L;
codeStruct.Bprim = Bprim;

%% create the data packet blocks

fillerBits = -1 * ones(1,F);

cbs = {};
dataReadOutPtr = 0;
for r = 0:(C-1)

    if r < Cmin
      Kr = Kmin;
    else
      Kr = Kplus;
    end

    ck = zeros(1,Kr);
%    ck(1:F)= fillerBits*0;
    if r==0
      ck(1:F)= fillerBits*0;

      ck((F+1:(Kr-L))) = dataIn_crc(dataReadOutPtr +[1:(Kr-F-L)]);
      dataReadOutPtr = dataReadOutPtr + (Kr - F - L);
    else
      ck(1:Kr-L) = dataIn_crc(dataReadOutPtr +[1:(Kr-L)]);
      dataReadOutPtr = dataReadOutPtr + (Kr - L);
    end

%    while k < Kr -L
%    end
    blockParityBits = ck;
    if C>1
%      blockParityBits = lteCRCEncode(blockParityBits(1:(Kr-L)),'24B');
       blockParityBits = dect_crc_enc_24B(blockParityBits(1:(Kr-L)));
    end
    if r==0
      blockParityBits(1:F)= fillerBits;
    end
    [n,m] = size(blockParityBits);
    if m>n
      blockParityBits = permute(blockParityBits,[2 1]);
    end
    cbs{r+1} = blockParityBits;

end


end
