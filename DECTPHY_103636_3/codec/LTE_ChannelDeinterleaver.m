%
% recovers the encoded vector from received puctured data
%

% Kalle Ruttik
% 30.10.2024

function [o] = LTE_ChannelDeinterleaver(in,K)

chPermColumns=[0, 16, 8, 24, 4, 20, 12, 28,...
                2, 18, 10, 26, 6, 22, 14, 30,...
                1, 17, 9, 25, 5, 21, 13, 29,...
		            3, 19, 11, 27, 7, 23, 15, 31];

K2 = K+4;

C_subblock_TC = 32;
R_subblock_TC = ceil((K+4)/C_subblock_TC);
K1 = C_subblock_TC*R_subblock_TC;
lenNULL = 32 - mod(K2,32);

v0 = in(1:K1);
v1 = in(K1+ [1:2:2*K1]);
v2 = in(K1+ [2:2:2*K1]);



k = 1;
for col = 1:C_subblock_TC
  for row = 1:R_subblock_TC
    if (row == 1) && (chPermColumns(col) < lenNULL)
      v0(k) = -1; v1(k) = -1;
    else
      inx = chPermColumns(col) + (row-1)*C_subblock_TC-lenNULL;
      d0(inx+1) = v0(k);  d1(inx+1) = v1(k);
    end

%    locV2 = chPermColumns( floor((k-1)/R_subblock_TC) +1) + mod(C_subblock_TC*mod((k-1),R_subblock_TC),K1);
    locV2 = mod(chPermColumns( floor((k-1)/R_subblock_TC) +1) + C_subblock_TC*mod((k-1),R_subblock_TC) +1 ,K1);
    if locV2 < lenNULL
      v2(k) =  -1;
    else
      d2(locV2+1-lenNULL) = v2(k);
    end
    k = k+1;
  end
end

o = [d0 d1 d2]';

end
